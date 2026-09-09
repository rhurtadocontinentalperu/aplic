&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CMOV FOR Almcmov.
DEFINE BUFFER B-DMOV FOR Almdmov.
DEFINE BUFFER ORDEN FOR FacCPedi.
DEFINE TEMP-TABLE t-Almcmov LIKE OOMoviAlmacen.
DEFINE TEMP-TABLE t-Detalle NO-UNDO LIKE logisdchequeo.



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
DEF INPUT PARAMETER pCodDoc  AS CHAR.
DEF INPUT PARAMETER pNroDoc  AS CHAR.
DEF INPUT PARAMETER x-UsrChq AS CHAR.
DEF INPUT PARAMETER pMotivo  AS CHAR.
DEF INPUT PARAMETER pObserv  AS CHAR.
DEF INPUT PARAMETER pLpn     AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR s-CodMov AS INTE INIT 09 NO-UNDO.

DEFINE VARIABLE S-CODDOC   AS CHAR INITIAL "D/F".

FIND FacDocum WHERE FacDocum.CodCia = S-CODCIA AND
     FacDocum.CodDoc = S-CODDOC 
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacDocum OR FacDocum.CodMov = 0 THEN DO:
   MESSAGE "Codigo de Documento no configurado" VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    S-CODMOV = FacDocum.CodMov.
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
     FacCorre.CodDoc = S-CODDOC AND
     FacCorre.CodDiv = S-CODDIV AND
     FacCorre.TipMov = 'I' AND
     FacCorre.CodMov = S-CODMOV AND
     FacCorre.FlgEst = YES
     NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   MESSAGE "Correlativo NO configurado: " s-CodDoc VIEW-AS ALERT-BOX ERROR.
   RETURN 'ADM-ERROR'.
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
   Temp-Tables and Buffers:
      TABLE: B-CMOV B "?" ? INTEGRAL Almcmov
      TABLE: B-DMOV B "?" ? INTEGRAL Almdmov
      TABLE: ORDEN B "?" ? INTEGRAL FacCPedi
      TABLE: t-Almcmov T "?" ? INTEGRAL OOMoviAlmacen
      TABLE: t-Detalle T "?" NO-UNDO INTEGRAL logisdchequeo
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

FIND Ccbcdocu WHERE Ccbcdocu.codcia = s-codcia
    AND Ccbcdocu.coddoc = pCodDoc
    AND Ccbcdocu.NroDoc = pNroDoc
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Ccbcdocu THEN RETURN ERROR.

DEFINE VARIABLE I-NRODOC       AS INTEGER NO-UNDO.
DEFINE VARIABLE I-NROSER       AS INTEGER NO-UNDO.
DEFINE VARIABLE pCuenta AS INTE NO-UNDO.

FIND FacCorre WHERE FacCorre.CodCia = S-CODCIA 
    AND FacCorre.CodDoc = S-CODDOC 
    AND FacCorre.CodDiv = S-CODDIV 
    /*AND FacCorre.CodAlm = S-CODALM*/
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
     
IF AVAILABLE FacCorre THEN ASSIGN I-NroSer = FacCorre.NroSer.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

  pMensaje = ''.
  CICLO:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      {lib/lock-genericov3.i ~
          &Tabla="Almacen" ~
          &Condicion="Almacen.CodCia = S-CODCIA AND Almacen.CodAlm = s-CodAlm" ~
          &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
          &Accion="RETRY" ~
          &Mensaje="NO" ~
          &txtMensaje="pMensaje" ~
          &TipoError="UNDO, LEAVE" ~
          }
      ASSIGN 
          I-NroDoc = Almacen.CorrIng
          Almacen.CorrIng = Almacen.CorrIng + 1.
      CREATE t-Almcmov.
      ASSIGN 
          t-Almcmov.CodCia = S-CodCia 
          t-Almcmov.CodAlm = s-CodAlm
          t-Almcmov.TipMov = "I"
          t-Almcmov.CodMov = S-CodMov 
          t-Almcmov.NroSer = 000
          t-Almcmov.NroDoc = I-NRODOC
          t-Almcmov.FchDoc = TODAY
          t-Almcmov.NroRef = Ccbcdocu.NroDoc
          t-Almcmov.TpoCmb = FacCfgGn.Tpocmb[1]
          t-Almcmov.FlgEst = "P"
          t-Almcmov.HorRcp = STRING(TIME,"HH:MM:SS")
          t-Almcmov.usuario = S-USER-ID
          t-Almcmov.NomRef  = Ccbcdocu.NomCli
          t-Almcmov.CodRef = Ccbcdocu.CodDoc
          t-Almcmov.NroRef = Ccbcdocu.NroDoc
          t-Almcmov.NroRf1 = Ccbcdocu.NroDoc
          t-Almcmov.Observ = pObserv
          t-Almcmov.Lpn    = pLpn
          NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
          {lib/mensaje-de-error.i ~
              &CuentaError="pCuenta" ~    /* OPCIONAL */
              &MensajeError="pMensaje" ~
              }
          UNDO CICLO, LEAVE.
      END.

      ASSIGN
          t-Almcmov.NroRf3 = pMotivo.
      
      RUN Numero-de-Documento(YES).
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          pMensaje = 'Error en el correlativo del No. de Devolución'.
          UNDO, LEAVE.
      END.
      ASSIGN 
          t-Almcmov.NroRf2 = STRING(I-NroSer,"999") + STRING(I-NroDoc,"999999").
      ASSIGN 
          t-Almcmov.CodCli = CcbCDocu.CodCli
          t-Almcmov.CodMon = CcbCDocu.CodMon.
          /*t-Almcmov.CodVen = CcbCDocu.CodVen.*/

      RUN Genera-Detalle.  /* Detalle de la Guia */ 
      IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
          IF TRUE <> (pMensaje > '')  THEN pMensaje = 'NO se pudo generar el detalle de la devolución'.
          UNDO, RETURN 'ADM-ERROR'.
      END.

      /* *************************************************************************************** */
      /* 12/04/2024: Se va a actualizar al momento de aprobar */
      /* *************************************************************************************** */
/*       RUN Actualiza-Factura(1).                                                               */
/*       IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                  */
/*           IF TRUE <> (pMensaje > '')  THEN pMensaje = 'NO se pudo actualizar el comprobante'. */
/*           UNDO, RETURN 'ADM-ERROR'.                                                           */
/*       END.                                                                                    */
  END.
  IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Factura) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Factura Procedure 
PROCEDURE Actualiza-Factura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER FACTOR AS INTEGER.

  DEFINE VARIABLE F-Des AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE F-Dev AS DECIMAL INIT 0 NO-UNDO.
  DEFINE VARIABLE C-SIT AS CHARACTER INIT "" NO-UNDO.
  DEFINE VARIABLE pCuenta AS INTE NO-UNDO.
  
  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
      FIND CURRENT CcbCDocu EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF ERROR-STATUS:ERROR THEN DO:
          {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
          UNDO RLOOP, RETURN 'ADM-ERROR'.                  
      END.
      FOR EACH OOMoviAlmacen NO-LOCK WHERE OOMoviAlmacen.CodCia = t-Almcmov.CodCia
          AND OOMoviAlmacen.CodAlm = t-Almcmov.CodAlm
          AND OOMoviAlmacen.TipMov = t-Almcmov.TipMov
          AND OOMoviAlmacen.CodMov = t-Almcmov.CodMov
          AND OOMoviAlmacen.NroSer = t-Almcmov.NroSer
          AND OOMoviAlmacen.NroDoc = t-Almcmov.NroDoc:
          FIND FIRST CcbDDocu OF Ccbcdocu WHERE CcbDDocu.CodMat = OOMoviAlmacen.CodMat 
              EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR THEN DO:
              {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
              UNDO RLOOP, RETURN 'ADM-ERROR'.                  
          END.
          ASSIGN 
              CcbDDocu.CanDev = CcbDDocu.CanDev + (FACTOR * OOMoviAlmacen.CanDes).
      END.
      IF Ccbcdocu.FlgEst <> 'A' THEN DO:
          FOR EACH CcbDDocu OF CcbCDocu NO-LOCK:
              F-Des = F-Des + CcbDDocu.CanDes.
              F-Dev = F-Dev + CcbDDocu.CanDev. 
          END.
          IF F-Dev > 0 THEN C-SIT = "P".
          IF F-Des = F-Dev THEN C-SIT = "D".
          ASSIGN 
              CcbCDocu.FlgCon = C-SIT.
      END.
      FIND CURRENT CcbCDocu NO-LOCK NO-ERROR.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Detalle Procedure 
PROCEDURE Genera-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Barremos lo chequeado
------------------------------------------------------------------------------*/

/* OJO: NO acumulamos, lo grabamos al detalle incluido el número de serie */

  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH LogisDChequeo NO-LOCK WHERE LogisDChequeo.CodCia = s-CodCia
          AND LogisDChequeo.CodDiv = s-CodDiv
          AND LogisDChequeo.CodPed = Ccbcdocu.CodDoc
          AND LogisDChequeo.NroPed = Ccbcdocu.NroDoc,
          FIRST Almmmatg OF LogisDChequeo NO-LOCK,
          FIRST Ccbddocu OF Ccbcdocu NO-LOCK WHERE Ccbddocu.codmat = LogisDChequeo.codmat:
          CREATE OOMoviAlmacen.
          BUFFER-COPY t-Almcmov TO OOMoviAlmacen
          ASSIGN 
              OOMoviAlmacen.CodCia = t-Almcmov.CodCia 
              OOMoviAlmacen.CodAlm = t-Almcmov.CodAlm 
              OOMoviAlmacen.TipMov = t-Almcmov.TipMov 
              OOMoviAlmacen.CodMov = t-Almcmov.CodMov 
              OOMoviAlmacen.NroSer = t-Almcmov.NroSer
              OOMoviAlmacen.NroDoc = t-Almcmov.NroDoc 
              OOMoviAlmacen.CodMon = t-Almcmov.CodMon 
              OOMoviAlmacen.FchDoc = t-Almcmov.FchDoc 
              OOMoviAlmacen.TpoCmb = t-Almcmov.TpoCmb 
              OOMoviAlmacen.codmat = LogisDChequeo.codmat
              OOMoviAlmacen.SerialNumber = logisdchequeo.SerialNumber
              OOMoviAlmacen.CanDes = LogisDChequeo.CanPed
              OOMoviAlmacen.CodUnd = LogisDChequeo.UndVta
              OOMoviAlmacen.Factor = 1
              OOMoviAlmacen.LinPreUni = ((Ccbddocu.ImpLin - Ccbddocu.ImpDto2) / Ccbddocu.CanDes )
              OOMoviAlmacen.CodAjt = '' 
              OOMoviAlmacen.LinImpLin = ROUND (OOMoviAlmacen.CanDes * OOMoviAlmacen.LinPreUni, 2)
              OOMoviAlmacen.AftIsc = Ccbddocu.AftIsc 
              OOMoviAlmacen.AftIgv = Ccbddocu.AftIgv 
              /*OOMoviAlmacen.Flg_factor = Ccbddocu.Flg_factor*/
              OOMoviAlmacen.HraDoc     = t-Almcmov.HorRcp
              .
          IF OOMoviAlmacen.AftIgv = YES THEN OOMoviAlmacen.LinImpIgv = ROUND(OOMoviAlmacen.LinImpLin / ( 1 + Ccbcdocu.PorIgv / 100) * Ccbcdocu.PorIgv / 100, 2).
          ASSIGN
              OOMoviAlmacen.MigFecha = TODAY
              OOMoviAlmacen.MigHora  = STRING(TIME, 'HH:MM:SS')
              OOMoviAlmacen.MigUsuario = s-user-id.
      END.
  END.
  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Numero-de-Documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Numero-de-Documento Procedure 
PROCEDURE Numero-de-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER L-INCREMENTA AS LOGICAL.

  IF L-INCREMENTA THEN 
      FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
        AND  FacCorre.CodDoc = S-CODDOC 
        AND  FacCorre.CodDiv = S-CODDIV 
        AND  FacCorre.FlgEst = YES
        EXCLUSIVE-LOCK NO-ERROR.
  ELSE
      FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA 
         AND  FacCorre.CodDoc = S-CODDOC 
         AND  FacCorre.CodDiv = S-CODDIV
         /*AND  FacCorre.CodAlm = S-CODALM */
         AND  FacCorre.FlgEst = YES
         NO-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR'.
  ASSIGN I-NroDoc = FacCorre.Correlativo.
  IF L-INCREMENTA THEN ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

