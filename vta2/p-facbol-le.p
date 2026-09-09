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
DEFINE TEMP-TABLE DOCU LIKE lima.Ccbcdocu.
DEFINE TEMP-TABLE DETA LIKE lima.CcbDDocu.

/* ***************************  Definitions  ************************** */
DEF INPUT PARAMETER pCodCia AS INT.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT-OUTPUT PARAMETER TABLE FOR DOCU.
DEF INPUT-OUTPUT PARAMETER TABLE FOR DETA.
DEF OUTPUT PARAMETER pError AS CHAR.

FIND lima.ccbcdocu WHERE lima.ccbcdocu.codcia = pCodCia
    AND lima.ccbcdocu.coddoc = pCodDoc
    AND lima.ccbcdocu.nrodoc = pNroDoc
    AND lima.ccbcdocu.divori = '00506'  /* SOLO Lista Express */
    AND lima.ccbcdocu.flgest <> 'A'
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE lima.ccbcdocu THEN DO:
    pError = "Documento no válido para Lista Express".
    RETURN 'ADM-ERROR'.
END.
EMPTY TEMP-TABLE DOCU.
EMPTY TEMP-TABLE DETA.
CREATE DOCU.
BUFFER-COPY lima.ccbcdocu TO DOCU.
FOR EACH lima.ccbddocu OF lima.ccbcdocu NO-LOCK:
    CREATE DETA.
    BUFFER-COPY lima.ccbddocu 
        TO DETA
        ASSIGN
        DETA.CanDes = (lima.Ccbddocu.candes - lima.Ccbddocu.candev)
        DETA.CanDev = (lima.CcbDDocu.CanDes - lima.CcbDDocu.CanDev)
        DETA.PreUni = ( lima.Ccbddocu.ImpLin - lima.Ccbddocu.ImpDto2 ) / lima.Ccbddocu.CanDes
        DETA.ImpLin = ROUND (DETA.CanDes * DETA.PreUni, 2).
    IF DETA.AftIgv = YES THEN DETA.ImpIgv = ROUND(DETA.ImpLin / ( 1 + DOCU.PorIgv / 100) * DOCU.PorIgv / 100, 2).
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


