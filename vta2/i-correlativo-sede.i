&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Controlar y el correlativo del documento

    Syntax      : {vtagn/i-faccorre-01.i 
                    &Codigo = <codigo del documento> 
                    &Serie = <número de serie> }

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

FIND VtaCorSed WHERE
    VtaCorSed.CodCia = s-CodCia AND
    VtaCorSed.CodDoc = {&Codigo} AND
    VtaCorSed.NroSer = {&Serie}
    EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE VtaCorSed THEN DO:
    MESSAGE "No se pudo actualizar el control de correlativos (VtaCorSed)" SKIP
        "para el documento" {&Codigo} "y la serie" {&Serie}
        VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN "ADM-ERROR".
END.

IF VtaCorSed.FlgCic = NO THEN DO:
    IF VtaCorSed.NroFin > 0 AND VtaCorSed.NroCor > VtaCorSed.NroFin THEN DO:
        MESSAGE 'Se ha llegado al límite del correlativo:' VtaCorSed.NroFin SKIP
            'No se puede generar el documento' {&Codigo} 'serie' {&Serie}
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN "ADM-ERROR".
    END.
END.

IF VtaCorSed.FlgCic = YES THEN DO:
    /* REGRESAMOS AL NUMERO 1 */
    IF VtaCorSed.NroFin > 0 AND VtaCorSed.NroCor > VtaCorSed.NroFin THEN DO:
        IF VtaCorSed.NroIni > 0 THEN VtaCorSed.NroCor = VtaCorSed.NroIni.
        ELSE VtaCorSed.NroCor = 1.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


