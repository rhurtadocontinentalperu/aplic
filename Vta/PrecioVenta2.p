&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE SHARED VAR s-coddiv AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.

DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR CL-CODCIA AS INT INIT 0 NO-UNDO.
DEF VAR x-ClfCli AS CHAR NO-UNDO.
DEF VAR x-fch AS DATE INIT TODAY.
DEF VAR j AS INTEGER NO-UNDO.

FIND Empresas WHERE Empresas.codcia = s-codcia NO-LOCK.
IF NOT Empresas.Campo-CodCli THEN CL-CODCIA = S-CODCIA.
FIND Almmmatg WHERE Almmmatg.codcia = S-CODCIA
    AND Almmmatg.codmat = S-CODMAT NO-LOCK.

/*********/
FIND gn-clie WHERE gn-clie.CodCia = cl-codcia 
   AND gn-clie.CodCli = S-CODCLI NO-LOCK NO-ERROR.
x-ClfCli = 'C'.     /* Valor por defecto */
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI = gn-clie.clfcli.

/* RHC 12.06.08 al tipo de cambio de la familia */
IF S-CODMON = 1 THEN DO:
  IF Almmmatg.MonVta = 1 THEN
      ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
  ELSE
      ASSIGN F-PREBAS = Almmmatg.PreOfi * Almmmatg.TpoCmb * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
  IF Almmmatg.MonVta = 2 THEN
     ASSIGN F-PREBAS = Almmmatg.PreOfi * F-FACTOR.
  ELSE
     ASSIGN F-PREBAS = (Almmmatg.PreOfi / Almmmatg.TpoCmb) * F-FACTOR.
END.

/* 13.11.09 RHC Clientes con listas especiales */
FIND Vtaclicam WHERE VtaCliCam.CodCia = cl-codcia
    AND VtaCliCam.CodCli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtaclicam AND (TODAY >= 12/01/2009 AND TODAY <= 03/31/2010) THEN DO:
    FIND Vtacatcam WHERE Vtacatcam.codcia = s-codcia
        AND Vtacatcam.codmat = s-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Vtacatcam THEN DO:
        IF S-CODMON = 1 THEN DO:
          IF Vtacatcam.MonVta = 1 THEN
              ASSIGN F-PREBAS = Vtacatcam.PreOfi * F-FACTOR.
          ELSE
              ASSIGN F-PREBAS = Vtacatcam.PreOfi * Vtacatcam.TpoCmb * F-FACTOR.
        END.
        IF S-CODMON = 2 THEN DO:
          IF Vtacatcam.MonVta = 2 THEN
             ASSIGN F-PREBAS = Vtacatcam.PreOfi * F-FACTOR.
          ELSE
             ASSIGN F-PREBAS = (Vtacatcam.PreOfi / Vtacatcam.TpoCmb) * F-FACTOR.
        END.
    END.
END.
/* *********************************************** */

MaxCat = 0.
MaxVta = 0.

FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
IF AVAIL ClfClie THEN DO:
  IF Almmmatg.Chr__02 = "P" THEN 
      MaxCat = ClfClie.PorDsc.
  ELSE 
      MaxCat = ClfClie.PorDsc1.
END.

FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA 
    AND Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

/***************************************************/

IF NOT AVAIL ClfClie THEN
    F-DSCTOS = (1 - (1 - MaxVta / 100)) * 100.
ELSE
    F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).


/*Precio Promocional*/
DO J = 1 TO 10:
    IF Almmmatg.PromDivi[J] = S-CODDIV 
        AND TODAY >= Almmmatg.PromFchD[J] 
        AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
        F-PREBAS = Almmmatg.Prevta[1] * F-FACTOR.
        F-DSCTOS = Almmmatg.PromDto[J] .         
        F-PREVTA = Almmmatg.Prevta[1] * (1 - F-DSCTOS / 100).
        IF S-CODMON = 1 THEN DO:
          IF Almmmatg.MonVta = 1 THEN
              ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
          ELSE
              ASSIGN F-PREVTA = F-PREVTA * Almmmatg.TpoCmb * F-FACTOR.
        END.
        IF S-CODMON = 2 THEN DO:
          IF Almmmatg.MonVta = 2 THEN
             ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
          ELSE
             ASSIGN F-PREVTA = (F-PREVTA / Almmmatg.TpoCmb) * F-FACTOR.
        END.        
     END.   
END.

/*MESSAGE F-PREBAS SKIP F-PREVTA.*/

    RUN src/BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


