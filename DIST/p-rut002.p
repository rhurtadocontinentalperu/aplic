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

/* RUTINA QUE DEVUELVE LA FECHA Y EL ESTADO DE LA HOJA DE RUTA PARA UN DOCUMEMTO ESPECIFICO */
DEF INPUT PARAMETER pTipo   AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pCodAlm AS CHAR.
DEF INPUT PARAMETER pTipMov AS CHAR.
DEF INPUT PARAMETER pCodMov AS INT.
DEF INPUT PARAMETER pSerRef AS INT.
DEF INPUT PARAMETER pNroRef AS INT.
DEF OUTPUT PARAMETER pHojRut   AS CHAR.
DEF OUTPUT PARAMETER pFlgEst-1 AS CHAR.
DEF OUTPUT PARAMETER pFlgEst-2 AS CHAR.
DEF OUTPUT PARAMETER pFchDoc AS DATE.

DEF SHARED VAR s-codcia AS INT.

ASSIGN
    pHojRut   = ""
    pFlgEst-1 = ""
    pFlgEst-2 = ""
    pFchDoc = ?.

/* Separamos de acuerdo al parametro pTipo */
CASE pTipo:
    WHEN "G/R" THEN DO:
        FIND LAST Di-RutaD WHERE Di-RutaD.codcia = s-codcia
            AND Di-RutaD.coddoc = "H/R"
            AND Di-RutaD.codref = pCodDoc
            AND Di-RutaD.nroref = pNroDoc
            AND CAN-FIND(LAST Di-RutaC USE-INDEX Llave02 OF Di-RutaD WHERE Di-RutaC.FlgEst <> "A"
                         NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaD THEN DO:
            FIND Di-RutaC OF Di-RutaD NO-LOCK.
            ASSIGN
                pHojRut   = Di-RutaC.NroDoc
                pFlgEst-1 = Di-RutaC.FlgEst
                pFlgEst-2 = Di-RutaD.FlgEst
                pFchDoc = Di-RutaC.FchDoc.
        END.
    END.
    WHEN "GRM" THEN DO:
        FIND LAST Di-RutaDG WHERE Di-RutaDG.codcia = s-codcia
            AND Di-RutaDG.coddoc = "H/R"
            AND Di-RutaDG.codref = pCodDoc
            AND Di-RutaDG.nroref = pNroDoc
            AND CAN-FIND(LAST Di-RutaC USE-INDEX Llave02 OF Di-RutaDG WHERE Di-RutaC.FlgEst <> "A"
                         NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaDG THEN DO:
            FIND Di-RutaC OF Di-RutaDG NO-LOCK.
            ASSIGN
                pHojRut   = Di-RutaC.NroDoc
                pFlgEst-1 = Di-RutaC.FlgEst
                pFlgEst-2 = Di-RutaDG.FlgEst
                pFchDoc = Di-RutaC.FchDoc.
        END.
    END.
    WHEN "TRF" THEN DO:
        FIND LAST Di-RutaG WHERE Di-RutaG.codcia = s-codcia
            AND Di-RutaG.coddoc = "H/R"
            AND Di-RutaG.codalm = pCodAlm
            AND Di-RutaG.tipmov = pTipMov
            AND Di-RutaG.codmov = pCodMov
            AND Di-RutaG.serref = pSerRef
            AND Di-RutaG.nroref = pNroRef
            AND CAN-FIND(LAST Di-RutaC USE-INDEX Llave02 OF Di-RutaG WHERE Di-RutaC.FlgEst <> "A"
                         NO-LOCK)
            NO-LOCK NO-ERROR.
        IF AVAILABLE Di-RutaG THEN DO:
            FIND Di-RutaC OF Di-RutaG NO-LOCK.
            ASSIGN
                pHojRut   = Di-RutaC.NroDoc
                pFlgEst-1 = Di-RutaC.FlgEst
                pFlgEst-2 = Di-RutaG.FlgEst
                pFchDoc = Di-RutaC.FchDoc.
        END.
    END.
END CASE.

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
         HEIGHT             = 3.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


