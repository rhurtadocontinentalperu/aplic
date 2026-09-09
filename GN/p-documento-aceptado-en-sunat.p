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

DEFINE INPUT PARAMETER pCodDoc AS CHAR.
DEFINE INPUT PARAMETER pNroDoc AS CHAR.
DEFINE INPUT PARAMETER pCodDiv AS CHAR.
DEFINE OUTPUT PARAMETER pRetVal AS CHAR NO-UNDO.

DEFINE SHARED VAR s-codcia AS INT.

pRetVal = "NO".

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND FIRST ccbcdocu WHERE ccbcdocu.codcia = s-codcia AND 
                            ccbcdocu.coddoc = pCodDoc AND
                            ccbcdocu.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE ccbcdocu THEN DO:
    pRetVal = "DOCUMENTO NO EXISTE, AL VERIFICAR SI EXISTE EN SUNAT".
    RETURN.
END.
IF ccbcdocu.flgest = 'A' THEN DO:
    pRetVal = "DOCUMENTO ESTA ANULADO, AL VERIFICAR SI EXISTE EN SUNAT".
    RETURN.
END.
FIND FIRST FELogcomprobantes WHERE FELogcomprobantes.codcia = s-codcia AND 
                            FELogcomprobantes.coddoc = pCodDoc AND
                            FELogcomprobantes.nrodoc = pNroDoc NO-LOCK NO-ERROR.
IF NOT AVAILABLE FELogcomprobantes THEN DO:
    pRetVal = "DOCUMENTO AUN NO ENVIADO A SUNAT".
    RETURN.
END.

DEFINE VAR x-Estado-BizLinks AS CHAR INIT "|".  
DEFINE VAR x-Estado-SUNAT AS CHAR INIT "|".
DEFINE VAR x-Estado-Doc AS CHAR INIT "".

IF FELogcomprobantes.id_pos <> "BIZLINKS" THEN DO:
    /* Fue enviado por PPL */
    pRetVal = "OK".
    RETURN.
END.

IF pCodDoc = 'BOL' OR (pCodDOc = 'N/C' AND FELogcomprobantes.tipodocrefpri = '03') THEN DO:
    /* Boletas y N/C que hacen referencia a Boletas */   
    IF ccbcdocu.fchdoc = TODAY THEN DO:
        pRetVal = "OK".
    END.
    ELSE DO:
        pRetVal = "OK".
    END.    

    RETURN.
END.
ELSE DO:
    /* Documento enviado a BAJA*/
    IF NOT (TRUE <> (felogcomprobantes.libre_c02 > "")) THEN DO:
        pRetVal = 'EL DOCUMENTO ESTA ENVIADO A DARSE DE BAJA EN SUNAT'.
        RETURN.
    END.
    ELSE DO:
        RUN gn/p-estado-documento-electronico.r(INPUT FELogcomprobantes.CodDoc,
                            INPUT FELogcomprobantes.NroDoc,
                            INPUT FELogcomprobantes.CodDiv,
                            OUTPUT x-estado-bizlinks,
                            OUTPUT x-estado-sunat,
                            OUTPUT x-estado-doc).

        IF ENTRY(1,x-estado-sunat,"|") = "AC_03" THEN DO:
            /* Aceptado por SUNAT */
            pRetVal = 'OK'.
        END.
        ELSE DO:
            pRetVal = x-estado-doc.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


