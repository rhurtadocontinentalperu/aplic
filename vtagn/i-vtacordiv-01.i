&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
DEF VAR vNroCor LIKE VtaCorDiv.NroCor NO-UNDO.
FIND Vtacordiv WHERE Vtacordiv.codcia = s-codcia
    AND Vtacordiv.coddiv = s-coddiv
    AND Vtacordiv.coddoc = s-codped
    AND Vtacordiv.nroser = s-nroser
    EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE Vtacordiv THEN DO:
    MESSAGE "No se pudo bloquear el control de correlativos"
        VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN "ADM-ERROR".
END.
vNroCor = VtaCorDiv.NroCor.
IF vNroCor < VtaCorDiv.NroIni THEN vNroCor = VtaCorDiv.NroIni.
IF VtaCorDiv.FlgCic = NO AND vNroCor > VtaCorDiv.NroFin THEN DO:
    MESSAGE 'El correlativo ha llegado a su límite' VIEW-AS ALERT-BOX WARNING.
    RELEASE VtaCorDiv.
    UNDO, RETURN 'ADM-ERROR'.
END.
IF VtaCorDiv.FlgCic = YES AND vNroCor > VtaCorDiv.NroFin THEN DO:
    vNroCor = VtaCorDiv.NroIni.
END.
ASSIGN
    VtaCorDiv.NroCor = vNroCor + 1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


