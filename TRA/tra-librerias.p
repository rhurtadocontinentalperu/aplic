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

DEF SHARED VAR s-codcia AS INT.

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
         HEIGHT             = 5.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Ingreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Ingreso Procedure 
PROCEDURE Actualiza-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodVeh AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.
DEF INPUT PARAMETER pConfirmado AS LOG.

IF NOT CAN-FIND(FIRST TraIngSal WHERE TraIngSal.CodCia = s-CodCia AND 
                TraIngSal.CodDiv = pCodDiv AND 
                TraIngSal.Placa = pCodVeh AND 
                TraIngSal.FlgEst = 'I' NO-LOCK)
    THEN RETURN 'OK'.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="TraIngSal" ~
        &Condicion="TraIngSal.CodCia = s-CodCia AND ~
            TraIngSal.CodDiv = pCodDiv AND ~
            TraIngSal.Placa = pCodVeh AND ~
            TraIngSal.FlgEst = 'I'" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        TraIngSal.NroDoc = pNroDoc.
    IF pConfirmado = YES THEN TraIngSal.FlgSit = "C".     /* Con H/R */
    ELSE TraIngSal.FlgSit = "X".        /* En trámite */
    RELEASE TraIngSal.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Extorna-Ingreso) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Ingreso Procedure 
PROCEDURE Extorna-Ingreso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodVeh AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.

IF TRUE <> (pCodVeh > '') THEN RETURN 'OK'.

IF NOT CAN-FIND(FIRST TraIngSal WHERE TraIngSal.CodCia = s-CodCia AND 
                TraIngSal.CodDiv = pCodDiv AND 
                TraIngSal.Placa = pCodVeh AND 
                TraIngSal.FlgEst = 'I' AND 
                LOOKUP(TraIngSal.FlgSit, 'X,C') > 0 AND 
                TraIngSal.NroDoc = pNroDoc NO-LOCK)
    THEN RETURN 'OK'.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="TraIngSal" ~
        &Condicion="TraIngSal.CodCia = s-CodCia AND ~
            TraIngSal.CodDiv = pCodDiv AND ~
            TraIngSal.Placa = pCodVeh AND ~
            TraIngSal.FlgEst = 'I' AND ~
            LOOKUP(TraIngSal.FlgSit, 'X,C') > 0 AND ~
            TraIngSal.NroDoc = pNroDoc" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    ASSIGN
        TraIngSal.NroDoc = ''
        TraIngSal.FlgSit = "P".     /* Sin H/R */
    RELEASE TraIngSal.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Flag-Estado) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Flag-Estado Procedure 
PROCEDURE Flag-Estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pFlgEst AS CHAR.
DEF OUTPUT PARAMETER pEstado AS CHAR.

CASE pFlgEst:
    WHEN 'X' THEN pEstado = "Falta Registar G/R".
    WHEN 'E' THEN pEstado = "Falta Chequear Bultos".
    WHEN 'P' THEN pEstado = "Pendiente".
    WHEN 'PS' THEN pEstado = "En Ruta".
    WHEN 'PR' THEN pEstado = "Ruta Terminada".
    WHEN 'C' THEN pEstado = "Cerrada".
    WHEN 'A' THEN pEstado = "Anulada".
    WHEN 'L' THEN pEstado = "Liquidado".
    OTHERWISE pEstado = pFlgEst + ": POR DEFINIR".
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

