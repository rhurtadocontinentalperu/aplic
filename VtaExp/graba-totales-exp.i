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
    VtaCDocu.ImpDto = 0
    VtaCDocu.ImpIgv = 0
    VtaCDocu.ImpIsc = 0
    VtaCDocu.ImpTot = 0
    VtaCDocu.ImpExo = 0
    VtaCDocu.Importe[3] = 0
    F-IGV = 0
    F-ISC = 0
    X-STANDFORD = 0
    X-LINEA1 = 0
    X-OTROS = 0
    Y-IMPTOT = 0.
  FOR EACH VtaDDocu OF VtaCDocu NO-LOCK: 
    F-Igv = F-Igv + VtaDDocu.ImpIgv.
    F-Isc = F-Isc + VtaDDocu.ImpIsc.
    VtaCDocu.ImpTot = VtaCDocu.ImpTot + VtaDDocu.ImpLin.
    IF NOT VtaDDocu.AftIgv THEN VtaCDocu.ImpExo = VtaCDocu.ImpExo + VtaDDocu.ImpLin.
    IF VtaDDocu.AftIgv = YES
    THEN VtaCDocu.ImpDto = VtaCDocu.ImpDto + ROUND(VtaDDocu.ImpDto / (1 + VtaCDocu.PorIgv / 100), 2).
    ELSE VtaCDocu.ImpDto = VtaCDocu.ImpDto + VtaDDocu.ImpDto.
    /******************Identificacion de Importes para Descuento**********/
    FIND Almmmatg WHERE Almmmatg.Codcia = S-CODCIA AND 
                         Almmmatg.Codmat = VtaDDocu.CodMat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        IF Almmmatg.CodFam = "002" AND Almmmatg.SubFam = "012" AND TRIM(Almmmatg.Desmar) = "STANDFORD" 
        THEN X-STANDFORD = X-STANDFORD + VtaDDocu.ImpLin.
        IF VtaDDocu.PorDto = 0 THEN DO:
           IF Almmmatg.CodFam = "001" 
           THEN X-LINEA1 = X-LINEA1 + VtaDDocu.ImpLin.
           ELSE X-OTROS = X-OTROS + VtaDDocu.ImpLin.
        END.                
    END.
    /*********************************************************************/
  END.
  Y-IMPTOT = ( X-LINEA1 + X-OTROS ) .   
  ASSIGN
    VtaCDocu.ImpIgv = ROUND(F-IGV,2)
    VtaCDocu.ImpIsc = ROUND(F-ISC,2)
    VtaCDocu.ImpVta = VtaCDocu.ImpTot - VtaCDocu.ImpExo - VtaCDocu.ImpIgv.
  IF VtaCDocu.PorDto > 0 THEN DO:
    ASSIGN
        VtaCDocu.ImpDto = VtaCDocu.ImpDto + ROUND((VtaCDocu.ImpVta + VtaCDocu.ImpExo) * VtaCDocu.PorDto / 100, 2)
        VtaCDocu.ImpTot = ROUND(VtaCDocu.ImpTot * (1 - VtaCDocu.PorDto / 100),2)
        VtaCDocu.ImpVta = ROUND(VtaCDocu.ImpVta * (1 - VtaCDocu.PorDto / 100),2)
        VtaCDocu.ImpExo = ROUND(VtaCDocu.ImpExo * (1 - VtaCDocu.PorDto / 100),2)
        VtaCDocu.ImpIgv = VtaCDocu.ImpTot - VtaCDocu.ImpExo - VtaCDocu.ImpVta.
  END.
  VtaCDocu.ImpBrt = VtaCDocu.ImpVta + VtaCDocu.ImpIsc + VtaCDocu.ImpDto + VtaCDocu.ImpExo.
  VtaCDocu.Importe[3] = IF Y-IMPTOT > VtaCDocu.ImpTot THEN VtaCDocu.ImpTot ELSE Y-IMPTOT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


