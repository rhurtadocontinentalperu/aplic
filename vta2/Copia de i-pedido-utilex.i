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
         HEIGHT             = 4
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/*   DEF VAR x-Familias-sin-Dsctos AS CHAR NO-UNDO.                                                                */
/*                                                                                                                 */
/*   x-Familias-sin-Dsctos = "000,011,008".                                                                        */
/*                                                                                                                 */
/*   CASE s-FlgSit:                                                                                                */
/*       WHEN "C" THEN DO:     /* CUPONES */                                                                       */
/*           FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = "99999"                                 */
/*               AND (TODAY >= 02/19/2011 AND TODAY <= 02/28/2011) NO-LOCK NO-ERROR.                               */
/*           IF AVAILABLE VtaListaMin                                                                              */
/*               THEN ASSIGN                                                                                       */
/*                         {&Tabla}.Libre_c04 = "C"                                                                */
/*                         {&Tabla}.Libre_c05 = "** PRECIO SUPEREBAJADO **".                                       */
/*       END.                                                                                                      */
/*       WHEN "T" THEN DO:                                                                                         */
/*           /* RHC Promociones por Bancos */                                                                      */
/*           CASE s-CodBko:                                                                                        */
/*               WHEN "WI" THEN DO:            /* Scotiabank */                                                    */
/*                   IF TODAY <= 03/10/2011 THEN DO:                                                               */
/*                       /* Definimos el mejor descuento */                                                        */
/*                       IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10 */
/*                           /*AND LOOKUP(Almmmatg.codfam, '001,002,010,012,013,014') > 0*/                        */
/*                           AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                */
/*                       THEN ASSIGN                                                                               */
/*                                 {&Tabla}.Por_Dsctos[1] = 0                                                      */
/*                                 {&Tabla}.Por_Dsctos[2] = 0                                                      */
/*                                 {&Tabla}.Por_Dsctos[3] = 0                                                      */
/*                                 {&Tabla}.Libre_c04 = "T,WI"                                                     */
/*                                 {&Tabla}.PorDto2 = 10.      /* 10% */                                           */
/*                       ELSE ASSIGN                                                                               */
/*                                 {&Tabla}.PorDto2 = 0.                                                           */
/*                   END.                                                                                          */
/*               END.                                                                                              */
/*               WHEN "CR" THEN DO:            /* Banco de Credito */                                              */
/*                   /* Solo Cuenta Sueldo */                                                                      */
/*                   IF s-Tarjeta = "05" AND TODAY <= 12/31/2011 THEN DO:                                          */
/*                       /* Definimos el mejor descuento */                                                        */
/*                       IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10 */
/*                           /*AND LOOKUP(Almmmatg.codfam, '001,002,010,012,013,014') > 0*/                        */
/*                           AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                */
/*                       THEN ASSIGN                                                                               */
/*                                 {&Tabla}.Por_Dsctos[1] = 0                                                      */
/*                                 {&Tabla}.Por_Dsctos[2] = 0                                                      */
/*                                 {&Tabla}.Por_Dsctos[3] = 0                                                      */
/*                                 {&Tabla}.Libre_c04 = "T,CR,05"                                                  */
/*                                 {&Tabla}.PorDto2 = 10.      /* 10% */                                           */
/*                       ELSE ASSIGN                                                                               */
/*                                 {&Tabla}.PorDto2 = 0.                                                           */
/*                   END.                                                                                          */
/*               END.                                                                                              */
/*           END CASE.                                                                                             */
/*       END.                                                                                                      */
/*       WHEN "V" THEN DO:                                                                                         */
/*           /* Definimos el mejor descuento */                                                                    */
/*           IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10             */
/*               AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                            */
/*           THEN ASSIGN                                                                                           */
/*                     {&Tabla}.Por_Dsctos[1] = 0                                                                  */
/*                     {&Tabla}.Por_Dsctos[2] = 0                                                                  */
/*                     {&Tabla}.Por_Dsctos[3] = 0                                                                  */
/*                     {&Tabla}.Libre_c04 = "V"                                                                    */
/*                     {&Tabla}.PorDto2 = 10.      /* 10% */                                                       */
/*           ELSE ASSIGN                                                                                           */
/*                     {&Tabla}.PorDto2 = 0.                                                                       */
/*       END.                                                                                                      */
/*       WHEN "X" THEN DO:                                                                                         */
/*           /* Definimos el mejor descuento */                                                                    */
/*           IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10             */
/*               AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                            */
/*           THEN ASSIGN                                                                                           */
/*                     {&Tabla}.Por_Dsctos[1] = 0                                                                  */
/*                     {&Tabla}.Por_Dsctos[2] = 0                                                                  */
/*                     {&Tabla}.Por_Dsctos[3] = 0                                                                  */
/*                     {&Tabla}.Libre_c04 = "X"                                                                    */
/*                     {&Tabla}.PorDto2 = 10.      /* 10% */                                                       */
/*           ELSE ASSIGN                                                                                           */
/*                     {&Tabla}.PorDto2 = 0.                                                                       */
/*       END.                                                                                                      */
/*       WHEN "K" THEN DO:                                                                                         */
/*           IF s-codpro = '10003814' THEN DO:     /* Tickets CONTINENTAL */                                       */
/*               /* Definimos el mejor descuento */                                                                */
/*               IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10         */
/*                   AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                        */
/*               THEN ASSIGN                                                                                       */
/*                         {&Tabla}.Por_Dsctos[1] = 0                                                              */
/*                         {&Tabla}.Por_Dsctos[2] = 0                                                              */
/*                         {&Tabla}.Por_Dsctos[3] = 0                                                              */
/*                         {&Tabla}.Libre_c04 = "K"                                                                */
/*                         {&Tabla}.PorDto2 = 10.      /* 5% */                                                    */
/*               ELSE ASSIGN                                                                                       */
/*                         {&Tabla}.PorDto2 = 0.                                                                   */
/*           END.                                                                                                  */
/*       END.                                                                                                      */
/*       WHEN "KC" THEN DO:    /* Tickets Continental para el personal */                                          */
/*           /* Definimos el mejor descuento */                                                                    */
/*           IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10             */
/*               AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                            */
/*           THEN ASSIGN                                                                                           */
/*                     {&Tabla}.Por_Dsctos[1] = 0                                                                  */
/*                     {&Tabla}.Por_Dsctos[2] = 0                                                                  */
/*                     {&Tabla}.Por_Dsctos[3] = 0                                                                  */
/*                     {&Tabla}.Libre_c04 = "KC"                                                                   */
/*                     {&Tabla}.PorDto2 = 10.                                                                      */
/*           ELSE ASSIGN                                                                                           */
/*                     {&Tabla}.PorDto2 = 0.                                                                       */
/*       END.                                                                                                      */
/*       WHEN "CD" THEN DO:        /* Cupón de Descuento */                                                        */
/*           IF TODAY <= 03/31/2012 THEN DO:                                                                       */
/*               /* Definimos el mejor descuento */                                                                */
/*               IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 5          */
/*                   AND LOOKUP(Almmmatg.codfam, x-Familias-sin-Dsctos) = 0                                        */
/*               THEN ASSIGN                                                                                       */
/*                         {&Tabla}.Por_Dsctos[1] = 0                                                              */
/*                         {&Tabla}.Por_Dsctos[2] = 0                                                              */
/*                         {&Tabla}.Por_Dsctos[3] = 0                                                              */
/*                         {&Tabla}.Libre_c04 = "CD"                                                               */
/*                         {&Tabla}.PorDto2 = 5.      /* 5% */                                                     */
/*               ELSE ASSIGN                                                                                       */
/*                         {&Tabla}.PorDto2 = 0.                                                                   */
/*           END.                                                                                                  */
/*       END.                                                                                                      */
/*   END CASE.                                                                                                     */

  CASE s-FlgSit:                                                                                                
      WHEN "CD" THEN DO:
          CASE TRUE:
              WHEN s-NroVale = "00755631" THEN DO:
                  IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 5
                      AND LOOKUP(Almmmatg.CodFam, '011,000,007') = 0     /* NO fotocopia, libros y cómputo */
                      AND NOT (Almmmatg.CodFam = '010' AND Almmmatg.SubFam = '007')     /* NO archivadores */
                      AND NOT (Almmmatg.CodFam = '001' AND Almmmatg.SubFam = '007')     /* NO archivadores */
                      AND NOT (Almmmatg.CodFam = '002' AND Almmmatg.SubFam = '030')     /* NO libros */
                      AND ( {&Tabla}.Por_Dsctos[1] = 0 AND {&Tabla}.Por_Dsctos[2] = 0
                            AND {&Tabla}.Por_Dsctos[3] = 0 ) /* NO promociones */
                      AND TODAY <= 02/15/2014
                      THEN DO:
                      ASSIGN
                          {&Tabla}.Por_Dsctos[1] = 0
                          {&Tabla}.Por_Dsctos[2] = 0
                          {&Tabla}.Por_Dsctos[3] = 0
                          {&Tabla}.Libre_c04 = "CD"
                          {&Tabla}.PorDto2 = 5.
                  END.
                  ELSE {&Tabla}.PorDto2 = 0.
              END.
              WHEN s-NroVale = "4122" THEN DO:
                  /* BUSCAMOS DESCUENTOS POR PRODUCTO */
                  FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
                      AND VtaTabla.tabla = "UTILEXD-CD"
                      AND VtaTabla.llave_c1 = '4122'
                      AND VtaTabla.llave_c2 = Almmmatg.codmat
                      NO-LOCK NO-ERROR.
                  IF AVAILABLE VtaTabla AND TODAY <= 10/31/2013 THEN DO:
                      ASSIGN
                          {&Tabla}.Por_Dsctos[1] = 0
                          {&Tabla}.Por_Dsctos[2] = 0
                          {&Tabla}.Por_Dsctos[3] = 0
                          {&Tabla}.Libre_c04 = "CD"
                          {&Tabla}.PorDto2 = VtaTabla.valor[1].
                  END.
                  ELSE {&Tabla}.PorDto2 = 0.
              END.
              WHEN s-NroVale = "45781" THEN DO:
                  IF ( LOOKUP(Almmmatg.CodFam, '000,011') = 0 AND
                      NOT ( Almmmatg.CodFam = "007" AND Almmmatg.SubFam = "002" ) )
                      AND TODAY <= 03/31/2014
                      THEN DO:
                      ASSIGN
                          {&Tabla}.Por_Dsctos[1] = 0
                          {&Tabla}.Por_Dsctos[2] = 0
                          {&Tabla}.Por_Dsctos[3] = 0
                          {&Tabla}.Libre_c04 = "CD"
                          {&Tabla}.PorDto2 = 10.
                      /* BUSCAMOS DESCUENTOS POR PRODUCTO */
                      FIND VtaTabla WHERE VtaTabla.codcia = s-codcia
                          AND VtaTabla.tabla = "UTILEXD-CD"
                          AND VtaTabla.llave_c1 = "45781"
                          AND VtaTabla.llave_c2 = Almmmatg.codmat
                          NO-LOCK NO-ERROR.
                      IF AVAILABLE VtaTabla THEN DO:
                          ASSIGN
                              {&Tabla}.PorDto2 = VtaTabla.valor[1].
                      END.
                  END.
                  ELSE {&Tabla}.PorDto2 = 0.
              END.
              WHEN s-NroVale = "075648" THEN DO:
                  IF MAXIMUM( {&Tabla}.Por_Dsctos[1], {&Tabla}.Por_Dsctos[2], {&Tabla}.Por_Dsctos[3] ) < 10
                      AND LOOKUP(Almmmatg.CodFam, '011,000') = 0     /* NO fotocopia y cómputo */
                      AND TODAY >= 11/27/2013 AND TODAY <= 12/31/2013 
                      THEN DO:
                      ASSIGN
                          {&Tabla}.Por_Dsctos[1] = 0
                          {&Tabla}.Por_Dsctos[2] = 0
                          {&Tabla}.Por_Dsctos[3] = 0
                          {&Tabla}.Libre_c04 = "CD"
                          {&Tabla}.PorDto2 = 10.
                  END.
                  ELSE {&Tabla}.PorDto2 = 0.
              END.
              WHEN s-NroVale = "2413" THEN DO:
                  IF ( LOOKUP(Almmmatg.CodFam, '000,007,008,009,011,015,050,888,999') = 0 AND
                      NOT ( Almmmatg.CodFam = "001" AND Almmmatg.SubFam = "007" ) AND
                      NOT ( Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "015" ) )
                      AND TODAY <= 03/31/2014
                      THEN DO:
                      ASSIGN
                          {&Tabla}.Por_Dsctos[1] = 0
                          {&Tabla}.Por_Dsctos[2] = 0
                          {&Tabla}.Por_Dsctos[3] = 0
                          {&Tabla}.Libre_c04 = "CD"
                          {&Tabla}.PorDto2 = 10.
                  END.
                  ELSE {&Tabla}.PorDto2 = 0.
              END.
          END CASE.
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


