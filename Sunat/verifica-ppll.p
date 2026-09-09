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

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pSUNAT AS LOG.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

DEF SHARED VAR s-CodCia AS INT.

pSUNAT = YES.    /* Está en SUNAT */
FIND FIRST FELogComprobantes WHERE FELogComprobantes.codcia = s-CodCia
    AND FELogComprobantes.coddiv = pCodDiv
    AND FELogComprobantes.coddoc = pCodDoc
    AND FELogComprobantes.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FELogComprobantes THEN DO:
    pSUNAT = NO.
    FIND FIRST Ccbdcaja WHERE Ccbdcaja.codcia = s-CodCia AND
        Ccbdcaja.codref = pCodDoc AND 
        Ccbdcaja.nroref = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbdcaja THEN DO:
        pMensaje = "Documento no enviado a SUNAT" + CHR(10) +
            "Por favor ANULAR la cobranza realizada (I/C nro : " + Ccbdcaja.NroDoc + ")" + CHR(10) +
            "y luego vuelva a cobrar el comprobante (" + pCodDoc + " - " + pNroDoc + ")".
    END.
    ELSE DO:
        pMensaje = "Documento aun no ha sido enviado a SUNAT".
    END.
    RETURN.
END.
IF TRUE <> (FELogComprobantes.codhash > "") THEN DO:
    pSUNAT = NO.
    FIND FIRST Ccbdcaja WHERE Ccbdcaja.codcia = s-CodCia AND
        Ccbdcaja.codref = pCodDoc AND 
        Ccbdcaja.nroref = pNroDoc NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbdcaja THEN DO:
        pMensaje =  "Documento no tiene el timbre (HASH)" + CHR(10) +
            "Por favor ANULAR la cobranza realizada (I/C nro : " + Ccbdcaja.NroDoc + ")" + CHR(10) +
            "y luego vuelva a cobrar el comprobante (" + pCodDoc + " - " + pNroDoc + ")".
    END.
    ELSE DO:
        pMensaje = "El documento NO TIENE el timbre(HASH) de seguridad de la SUNAT".
    END.
END.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


