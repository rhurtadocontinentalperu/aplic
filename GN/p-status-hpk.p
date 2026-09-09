&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Determina el status de pedido de acuerdo al ultimo evento

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF OUTPUT PARAMETER pStatus AS CHAR.

DEF SHARED VAR s-codcia AS INT.

pStatus = 'NO DEFINIDO'.
FOR EACH LogTrkDocs NO-LOCK WHERE LogTrkDocs.CodCia = s-codcia AND
    LogTrkDocs.CodDoc = pCodDoc AND
    LogTrkDocs.NroDoc = pNroDoc AND
    LogTrkDocs.Clave = 'TRCKHPK'
    BY LogTrkDocs.Orden BY LogTrkDocs.Fecha:
    pStatus = LogTrkDocs.Codigo.
END.
FIND FIRST TabTrkDocs WHERE TabTrkDocs.CodCia = s-CodCia
    AND TabTrkDocs.Clave = 'TRCKHPK'
    AND TabTrkDocs.Codigo = pStatus NO-LOCK NO-ERROR.
IF AVAILABLE TabTrkDocs THEN pStatus = TabTrkDocs.NomCorto.

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
         HEIGHT             = 5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


