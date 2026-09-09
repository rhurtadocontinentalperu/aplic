&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Ubigeo del cliente

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCia AS INT.                                    
DEF INPUT PARAMETER pCodCli AS CHAR.
DEF OUTPUT PARAMETER pCodDepto AS CHAR.
DEF OUTPUT PARAMETER pNomDepto AS CHAR.
DEF OUTPUT PARAMETER pCodProvi AS CHAR.
DEF OUTPUT PARAMETER pNomProvi AS CHAR.
DEF OUTPUT PARAMETER pCodDistr AS CHAR.
DEF OUTPUT PARAMETER pNomDistr AS CHAR.

ASSIGN
    pCodDepto = ''
    pNomDepto = ''
    pCodProvi = ''
    pNomProvi = ''
    pCodDistr = ''
    pNomDistr = ''.
FIND gn-clie WHERE gn-clie.codcia = pcodcia AND gn-clie.codcli = pcodcli NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN RETURN.
ASSIGN
    pCodDepto = gn-clie.CodDept 
    pCodProvi = gn-clie.CodProv 
    pCodDistr = gn-clie.CodDist.
FIND TabDepto WHERE TabDepto.CodDepto = pCodDepto NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabDepto THEN RETURN.
pNomDepto = TabDepto.NomDepto.
FIND TabProvi WHERE TabProvi.CodDepto = pCodDepto 
    AND TabProvi.CodProvi = pCodprovi NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabProvi THEN RETURN.
pNomProvi = TabProvi.NomProvi.
FIND TabDistr WHERE TabDistr.CodDepto = pCodDepto
    AND TabDistr.CodProvi = pCodProvi
    AND TabDistr.CodDistr = pCodDistr
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabDistr THEN RETURN.
pNomDistr = TabDistr.NomDistr.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


