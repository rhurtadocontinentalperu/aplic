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

/* GRABACION DEL TRACKING DE PEDIDOS */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pClave AS CHAR.
DEF INPUT PARAMETER pCodigo AS CHAR.
DEF INPUT PARAMETER pUsuario AS CHAR.
DEF INPUT PARAMETER pFecha AS DATETIME.

IF LOOKUP(pCodDoc, 'O/D,O/M,OTR,HPK') = 0 THEN RETURN.

/* NOTA: la pClave y pCodigo deben estar registrados en la tabla TabTrkDocs */
FIND TabTrkDocs WHERE TabTrkDocs.CodCia = s-codcia AND
    TabTrkDocs.Clave = pClave AND 
    TabTrkDocs.Codigo = pCodigo NO-LOCK NO-ERROR.
IF NOT AVAILABLE TabTrkDocs THEN DO:
    MESSAGE 'Clave:' pClave 'y código:' pCodigo 'NO registrados en la tabla TabTrkDocs'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.

CREATE LogTrkDocs.
ASSIGN
    LogTrkDocs.CodCia = s-codcia
    LogTrkDocs.Clave = pClave
    LogTrkDocs.Codigo = pCodigo
    LogTrkDocs.Orden = TabTrkDocs.Orden
    LogTrkDocs.CodDoc = pCodDoc
    LogTrkDocs.NroDoc = pNroDoc
    LogTrkDocs.CodDiv = s-CodDiv
    LogTrkDocs.Fecha = NOW
    LogTrkDocs.Usuario = s-user-id.
IF pUsuario > '' THEN LogTrkDocs.Usuario = pUsuario.
IF pFecha <> ? THEN LogTrkDocs.Fecha = pFecha.

/* CASE pCodigo:                                                                                         */
/*     WHEN "SI_ALM" THEN DO:      /* SOLO IMPRESOS */                                                   */
/*         FIND Faccpedi WHERE Faccpedi.codcia = s-codcia AND                                            */
/*             Faccpedi.coddoc = pCodDoc AND                                                             */
/*             Faccpedi.nroped = pNroDoc                                                                 */
/*             NO-LOCK NO-ERROR.                                                                         */
/*         IF AVAILABLE Faccpedi AND Faccpedi.UsrImpOD > '' THEN LogTrkDocs.Usuario = Faccpedi.UsrImpOD. */
/*         IF AVAILABLE Faccpedi AND Faccpedi.FchImpOD <> ? THEN LogTrkDocs.Fecha = Faccpedi.FchImpOD.   */
/*     END.                                                                                              */
/* END CASE.                                                                                             */

RELEASE LogTrkDocs.

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
         HEIGHT             = 4.42
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


