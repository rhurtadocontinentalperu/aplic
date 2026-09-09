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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* ACTUALIZA LA COTIZACION EN BASE AL PEDIDO AL CREDITO */

  DEFINE INPUT PARAMETER pRowid AS ROWID.
  DEFINE INPUT PARAMETER pFactor AS INT.    /* +1 actualiza    -1 desactualiza */

  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  DEFINE BUFFER B-DPEDI FOR VtaDDocu.
  DEFINE BUFFER B-CPEDI FOR VtaCDocu.

  FIND VtaCDocu WHERE ROWID(VtaCDocu) = pRowid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE VtaCDocu THEN RETURN 'ADM-ERROR'.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FOR EACH VtaDDocu OF VtaCDocu NO-LOCK:
          FIND B-DPedi WHERE B-DPedi.CodCia = VtaCDocu.CodCia 
              AND B-DPedi.CodPed = VtaCDocu.CodRef
              AND B-DPedi.NroPed = VtaCDocu.NroRef   
              AND B-DPedi.CodMat = VtaDDocu.CodMat 
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-DPedi THEN DO:
              B-DPedi.CanAte = B-DPedi.CanAte + ( VtaDDocu.CanPed * pFactor ).
          END.
          RELEASE B-DPedi.
      END.
      FOR EACH VtaDDocu NO-LOCK WHERE VtaDDocu.CodCia = VtaCDocu.CodCia
          AND VtaDDocu.CodPed = VtaCDocu.CodRef
          AND VtaDDocu.NroPed = VtaCDocu.NroRef:     
          IF (VtaDDocu.CanPed - VtaDDocu.CanAte) > 0 
          THEN DO:
             I-NRO = 1.
             LEAVE.
          END.
      END.
      /* RHC 22-03-2003 */
      FIND B-CPedi WHERE B-CPedi.CodCia = VtaCDocu.CodCia
          AND  B-CPedi.CodDiv = VtaCDocu.CodDiv
          AND  B-CPedi.CodPed = VtaCDocu.CodRef 
          AND  B-CPedi.NroPed = VtaCDocu.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CPedi THEN DO:
          IF I-NRO = 0 
          THEN ASSIGN B-CPedi.FlgEst = "C".
          ELSE ASSIGN B-CPedi.FlgEst = "P".
      END.
      RELEASE B-CPedi.
  END.
  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


