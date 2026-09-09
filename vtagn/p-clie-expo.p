&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Verificar que el cliente sea válido

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodCli AS CHAR.
DEF INPUT PARAMETER pTpoPed AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR cl-codcia AS INT.

IF pTpoPed <> "E" THEN RETURN 'OK'.     /* SOLO Expolibreria */

/* IF pCodDiv = '10060' AND TODAY <= DATE(10,31,2016) THEN RETURN 'OK'. */
/* IF pCodDiv = '10015' AND TODAY <= DATE(03,31,2017) THEN RETURN 'OK'. */

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
         HEIGHT             = 3.85
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND Vtaclivip WHERE Vtaclivip.codcia = cl-codcia
    AND Vtaclivip.codcli = pCodCli
    AND Vtaclivip.coddiv = pCodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Vtaclivip THEN DO:
    MESSAGE 'Cliente' pCodCli 'no registrado en la lista de Expolibreria'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


