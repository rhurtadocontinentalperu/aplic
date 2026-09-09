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
         HEIGHT             = 4.19
         WIDTH              = 46.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pCodPed AS CHAR.
DEF INPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

DEF SHARED VAR s-codcia AS INT.

IF TRUE <> (pCodDiv > '') THEN DO:
    FIND LAST LogTrkDocs WHERE LogTrkDocs.CodCia = s-CodCia AND
        LogTrkDocs.Clave = 'TRCKPED' AND
        LogTrkDocs.CodDoc = pCodPed AND
        LogTrkDocs.NroDoc = pNroPed AND
        CAN-FIND(FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia AND
                 TabTrkDocs.Clave = LogTrkDocs.Clave AND
                 TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK)
        NO-LOCK NO-ERROR.
END.
ELSE DO:
    FIND LAST LogTrkDocs WHERE LogTrkDocs.CodCia = s-CodCia AND
        LogTrkDocs.Clave = 'TRCKPED' AND
        LogTrkDocs.CodDoc = pCodPed AND
        LogTrkDocs.NroDoc = pNroPed AND
        LogTrkDocs.CodDiv = pCodDiv AND
        CAN-FIND(FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia AND
                 TabTrkDocs.Clave = LogTrkDocs.Clave AND
                 TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK)
        NO-LOCK NO-ERROR.
END.
IF AVAILABLE LOgTrkDocs THEN DO:
    FIND FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = LogTrkDocs.CodCia AND
        TabTrkDocs.Clave = LogTrkDocs.Clave AND
        TabTrkDocs.Codigo = LogTrkDocs.Codigo NO-LOCK NO-ERROR.
    IF AVAILABLE TabTrkDocs THEN pEstado = TabTrkDocs.NomCorto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


