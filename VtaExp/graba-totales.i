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


  DEFINE VARIABLE F-IGV AS DECIMAL NO-UNDO.
  DEFINE VARIABLE F-ISC AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-STANDFORD AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-LINEA1 AS DECIMAL NO-UNDO.
  DEFINE VARIABLE X-OTROS AS DECIMAL NO-UNDO.
  DEFINE VARIABLE Y-IMPTOT AS DECIMAL NO-UNDO.

  ASSIGN
    FacCPedi.ImpDto = 0
    FacCPedi.ImpIgv = 0
    FacCPedi.ImpIsc = 0
    FacCPedi.ImpTot = 0
    FacCPedi.ImpExo = 0
    FacCPedi.Importe[3] = 0.
  FOR EACH FacDPedi OF FacCPedi NO-LOCK: 
    FacCPedi.ImpDto = FacCPedi.ImpDto + FacDPedi.ImpDto.
    F-Igv = F-Igv + FacDPedi.ImpIgv.
    F-Isc = F-Isc + FacDPedi.ImpIsc.
    FacCPedi.ImpTot = FacCPedi.ImpTot + FacDPedi.ImpLin.
    IF NOT FacDPedi.AftIgv THEN FacCPedi.ImpExo = FacCPedi.ImpExo + FacDPedi.ImpLin.
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
    FacCPedi.ImpIsc = ROUND(F-ISC,2)
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                        FacCPedi.ImpDto - FacCPedi.ImpExo
    FacCPedi.ImpVta = FacCPedi.ImpBrt - FacCPedi.ImpDto
    FacCPedi.ImpDto = FacCPedi.ImpDto + ROUND(FacCPedi.ImpTot * FacCPedi.PorDto / 100,2)
    FacCPedi.ImpTot = ROUND(FacCPedi.ImpTot * (1 - FacCPedi.PorDto / 100),2)
    FacCPedi.ImpVta = ROUND(FacCPedi.ImpTot / (1 + FacCPedi.PorIgv / 100),2)
    FacCPedi.ImpIgv = FacCPedi.ImpTot - FacCPedi.ImpVta
    FacCPedi.ImpBrt = FacCPedi.ImpTot - FacCPedi.ImpIgv - FacCPedi.ImpIsc + 
                        FacCPedi.ImpDto - FacCPedi.ImpExo.
    FacCPedi.Importe[3] = IF Y-IMPTOT > FacCPedi.ImpTot THEN FacCPedi.ImpTot ELSE Y-IMPTOT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


