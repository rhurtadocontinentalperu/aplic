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

/* Validación de duplicidad de boletas de depósito */
DEF INPUT PARAMETER pNewRecord AS CHAR.     /* YES o NO */
DEF INPUT PARAMETER pCodDoc AS CHAR.        /* BD */
DEF INPUT PARAMETER pNroDoc AS CHAR.        /* Nro de deposito */
DEF INPUT PARAMETER pCodBco AS CHAR.
DEF INPUT PARAMETER pNroDeposito AS CHAR.
DEF INPUT PARAMETER pFchDeposito AS DATE.
DEF INPUT PARAMETER pImporte AS DEC.
DEF OUTPUT PARAMETER pDuplicado AS LOG.     /* YES duplicado  NO no duplicado */
DEF OUTPUT PARAMETER pError AS CHAR.

DEF SHARED VAR s-codcia AS INT.
DEF BUFFER B-Ccbcdocu FOR Ccbcdocu.

pDuplicado = YES.
SESSION:SET-WAIT-STATE('GENERAL').
CASE pNewRecord:
    WHEN "YES" THEN DO:
        FIND FIRST B-Ccbcdocu WHERE B-Ccbcdocu.CodCia = S-CODCIA 
            AND B-Ccbcdocu.CodDoc = pCodDoc
            AND B-Ccbcdocu.FlgAte = pCodBco 
            AND B-Ccbcdocu.NroRef = pNroDeposito
            AND B-Ccbcdocu.FchAte = pFchDeposito
            AND B-Ccbcdocu.FlgEst <> "A"    /* NO anulados solamente */
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b-Ccbcdocu THEN pDuplicado = NO.
        ELSE pError = "DUPLICADO en la división " + B-Ccbcdocu.coddiv + " " + 
            "con el correlativo " + B-Ccbcdocu.nrodoc.
    END.
    WHEN "NO" THEN DO:
        FIND FIRST B-Ccbcdocu WHERE B-Ccbcdocu.CodCia = S-CODCIA 
            AND B-Ccbcdocu.CodDoc = pCodDoc
            AND B-Ccbcdocu.FlgAte = pCodBco 
            AND B-Ccbcdocu.NroRef = pNroDeposito
            AND B-Ccbcdocu.NroDoc <> pNroDoc 
            AND B-Ccbcdocu.ImpTot = pImporte
            AND B-Ccbcdocu.FchAte = pFchDeposito
            AND LOOKUP(TRIM(B-Ccbcdocu.FlgEst), "A,R") = 0    /* NO anulados o rechazados */
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE b-Ccbcdocu THEN pDuplicado = NO.
        ELSE pError = "DUPLICADO en la división " + B-Ccbcdocu.coddiv + " " + 
            "con el correlativo " + B-Ccbcdocu.nrodoc.
    END.
END CASE.
SESSION:SET-WAIT-STATE('').

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
         HEIGHT             = 4.54
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


