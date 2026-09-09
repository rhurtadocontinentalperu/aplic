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

/* DEVOLVER EL NÚMERO DE BULTOS */
/* DEBIDO A UN CASO DETECTADO:
    H/R 43236
    O/D 111033713
*/
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pBultos AS INT.

DEF SHARED VAR s-codcia AS INT.

pBultos = 0.

/* 1ro buscamos en la división sugerida */
FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-CodCia AND 
    CcbCBult.CodDiv = pCodDiv AND
    CcbCBult.CodDoc = pCodDoc AND   /* Debería ser una O/D u OTR */
    CcbCBult.NroDoc = pNroDoc:
    pBultos = pBultos + CcbCBult.Bultos.
END.
IF pBultos > 0 THEN RETURN.

/* 2do. veamos si ha sido reprogramado */
FIND FIRST LogTabla WHERE logtabla.codcia = s-CodCia AND
    logtabla.Evento = 'REPROGRAMACION' AND
    logtabla.Tabla = 'ALMCDOCU' AND
    logtabla.ValorLlave BEGINS pCodDiv + '|' + pCodDoc + '|' + pNroDoc
    NO-LOCK NO-ERROR.
IF AVAILABLE LogTabla THEN DO:
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-CodCia AND 
        CcbCBult.CodDoc = pCodDoc AND   /* Debería ser una O/D u OTR */
        CcbCBult.NroDoc = pNroDoc:
        pBultos = pBultos + CcbCBult.Bultos.
    END.
END.
IF pBultos > 0 THEN RETURN.

/* 3ro. Si todo falla ... */
FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = s-CodCia AND 
    CcbCBult.CodDoc = pCodDoc AND   /* Debería ser una O/D u OTR */
    CcbCBult.NroDoc = pNroDoc:
    pBultos = pBultos + CcbCBult.Bultos.
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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


