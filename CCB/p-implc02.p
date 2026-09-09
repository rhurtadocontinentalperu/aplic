&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER dMonLC AS INT.
DEF OUTPUT PARAMETER pImpLCred AS DEC.
DEF OUTPUT PARAMETER pFchLCred AS DATE.

DEF VAR lEnCampan AS LOG NO-UNDO.

/* Línea Crédito Campaña */
pImpLCred = 0.
lEnCampan = FALSE.
FIND gn-clie WHERE gn-clie.codcia = pcodcia
    AND gn-clie.codcli = pcodcli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.

FOR EACH Gn-ClieL WHERE Gn-ClieL.CodCia = pcodcia 
    AND Gn-ClieL.CodCli = pcodcli 
    AND TODAY >= Gn-ClieL.FchIni 
    AND TODAY <= Gn-ClieL.FchFin NO-LOCK
    BY gn-cliel.fchini BY gn-cliel.fchfin:
    dMonLC    = gn-cliel.monlc.
    pImpLCred = /*pImpLCred +*/ Gn-ClieL.ImpLC.
    pFchLCred = Gn-ClieL.FchFin.
    lEnCampan = TRUE.
END.
/* Línea Crédito Normal 
RD01 - Ya no verifica en maestro de clientes.
IF NOT lEnCampan THEN 
    ASSIGN 
        pImpLCred = gn-clie.ImpLC
        pFchLCred = Gn-Clie.FchVLC.
***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


