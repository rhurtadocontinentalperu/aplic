&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Importe total para FacCPedi (COT PED O/D P/M)

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

  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-LINEA1 AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-OTROS AS DECIMAL NO-UNDO.
  DEFINE VARIABLE Y-IMPTOT AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-ImpDto2 AS DEC NO-UNDO.
  
  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpDto2 = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[3] = 0
    F-IGV = 0
    F-ISC = 0
    X-STANDFORD = 0
    X-LINEA1 = 0
    X-OTROS = 0
    Y-IMPTOT = 0.
    x-ImpDto2 = 0.
    
  FOR EACH FacDPedi OF FacCPedi NO-LOCK: 
    F-Igv = F-Igv + FacDPedi.ImpIgv.
    F-Isc = F-Isc + FacDPedi.ImpIsc.
    x-ImpDto2 = x-ImpDto2 + FacDPedi.ImpDto2.

    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    FacCPedi.ImpDto2 = FacCPedi.ImpDto2 + FacDPedi.ImpDto2.

    IF NOT FacDPedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.
    IF FacDPedi.AftIgv = YES
    THEN FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacDPedi.ImpDto / (1 + FacCPedi.PorIgv / 100), 2).
    ELSE FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.
    /******************Identificacion de Importes para Descuento**********/
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND 
                         Almmmatg.Codmat = FacDPedi.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        IF Almmmatg.CodFam = "002" AND Almmmatg.SubFam = "012" AND TRIM(Almmmatg.Desmar) = "STANDFORD" 
        THEN X-STANDFORD = X-STANDFORD + FacDPedi.ImpLin.
        IF FacDPedi.Por_Dsctos[3] = 0 THEN DO:
           IF Almmmatg.CodFam = "001" 
           THEN X-LINEA1 = X-LINEA1 + FacDPedi.ImpLin.
           ELSE X-OTROS = X-OTROS + FacDPedi.ImpLin.
        END.                
    END.
    /*********************************************************************/
  END.
  Y-IMPTOT = ( X-LINEA1 + X-OTROS ) .   
  ASSIGN
    FacCPedi.ImpIgv = ROUND(F-IGV,2)
    FacCPedi.ImpIsc = ROUND(F-ISC,2).
  /* RHC Descuentos Topes por Tarjetas de Credito */
  IF Faccpedi.ImpDto2 > 0 THEN DO:
      CASE FacCPedi.FlgSit:
          WHEN "T" THEN DO:
              CASE FacCPedi.Libre_C03:
                  WHEN "WI" THEN DO:                /* Scotiabank */
                      IF Faccpedi.Libre_c03 = "WI" AND TODAY <= 03/10/2011 
                          THEN Faccpedi.ImpDto2 = MINIMUM(Faccpedi.ImpDto2, 50).   /* TOPE DE S/.50 */
                  END.
                  WHEN "CR" THEN DO:                /* Banco de CRedito Cuenta Sueldo */
                      IF Faccpedi.Libre_c03 = "CR" AND Faccpedi.Libre_c04 = "05" AND TODAY <= 12/31/2011 
                          THEN Faccpedi.ImpDto2 = MINIMUM(Faccpedi.ImpDto2, 1000000).   /* TOPE DE S/.100000 */
                  END.
              END CASE.
              /* RHC 17.02.2011 RECALCULAMOS LOS IMPORTES DE DESCUENTO POR TARJETAS */
              IF x-ImpDto2 <> Faccpedi.ImpDto2 THEN DO:
                  FOR EACH Facdpedi OF Faccpedi WHERE Facdpedi.PorDto2 > 0:
                      Facdpedi.ImpDto2 = ROUND (Facdpedi.ImpDto2 * ( Faccpedi.ImpDto2 / x-ImpDto2 ), 2).
                  END.
              END.
              /* ****************************************************************** */
              ASSIGN
                  Faccpedi.ImpTot = Faccpedi.ImpTot - Faccpedi.ImpDto2
                  Faccpedi.ImpIgv = Faccpedi.ImpIgv - ROUND( Faccpedi.ImpDto2 / (1 + Faccpedi.PorIgv / 100) * Faccpedi.PorIgv / 100, 2).
          END.
          WHEN "V" OR WHEN "X" OR WHEN "K" OR WHEN "CD" OR WHEN "KC" THEN DO:
              ASSIGN
                  Faccpedi.ImpTot = Faccpedi.ImpTot - Faccpedi.ImpDto2
                  Faccpedi.ImpIgv = Faccpedi.ImpIgv - ROUND( Faccpedi.ImpDto2 / (1 + Faccpedi.PorIgv / 100) * Faccpedi.PorIgv / 100, 2).
          END.
      END CASE.
  END.
  ASSIGN
      FacCPedi.ImpVta = FacCPedi.ImpTot - FacCPedi.ImpExo - FacCPedi.ImpIgv.
  ASSIGN
      FacCPedi.ImpBrt = FacCPedi.ImpVta + FacCPedi.ImpIsc + FacCPedi.ImpDto + FacCPedi.ImpExo
      FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


