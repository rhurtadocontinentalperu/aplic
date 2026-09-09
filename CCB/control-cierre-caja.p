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
IF TODAY < DATE(04,01,2016) THEN RETURN 'OK'.

DEF INPUT PARAMETER s-codcia AS INT.
DEF INPUT PARAMETER s-coddiv AS CHAR.
DEF INPUT PARAMETER s-user-id AS CHAR.
DEF INPUT PARAMETER s-codter AS CHAR.

FIND FIRST Ccbccaja WHERE CcbCCaja.CodCia = s-codcia
    AND CcbCCaja.CodDiv = s-coddiv
    AND LOOKUP(CcbCCaja.CodDoc, 'I/C,E/C') > 0
    AND CcbCCaja.usuario = s-user-id
    AND CcbCCaja.CodCaja = s-codter
    AND CcbCCaja.FlgCie = 'P'
    AND CcbCCaja.FlgEst <> 'A'
    AND CcbCCaja.FchDoc < TODAY
    NO-LOCK NO-ERROR.
IF AVAILABLE CcbCCaja THEN DO:
    MESSAGE 'Usuario NO cerró su caja el día anterior' SKIP
        'Documento:' Ccbccaja.CodDoc Ccbccaja.NroDoc SKIP
        'Proceso incompleto. Debe culminar proceso para inicio de operaciones.'
        VIEW-AS ALERT-BOX WARNING.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

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
         HEIGHT             = 3.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


