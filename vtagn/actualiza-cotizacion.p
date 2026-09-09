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
         HEIGHT             = 4.23
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

  DEFINE BUFFER B-DPEDI FOR FacDPedi.
  DEFINE BUFFER B-CPEDI FOR FacCPedi.

  FIND Faccpedi WHERE ROWID(Faccpedi) = pRowid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN 'ADM-ERROR'.

  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      /* RHC 13.01.2012 NO PROMOCIONES */
      FOR EACH facdPedi OF faccPedi NO-LOCK WHERE Facdpedi.Libre_c05 <> "OF":
          FIND FIRST B-DPedi WHERE B-DPedi.CodCia = faccPedi.CodCia 
              AND B-DPedi.CodDiv = FacCPedi.CodDiv
              AND B-DPedi.CodDoc = FacCPedi.CodRef      /* COT */
              AND B-DPedi.NroPed = FacCPedi.NroRef   
              AND B-DPedi.CodMat = FacDPedi.CodMat 
              EXCLUSIVE-LOCK NO-ERROR.
          IF AVAILABLE B-DPedi THEN DO:
              B-DPedi.CanAte = B-DPedi.CanAte + ( (Facdpedi.CanPed - Facdpedi.CanAte) * pFactor ).
              /* RHC 13.01.2011 CONTROL DE ATENCIONES */
              IF B-DPEDI.CanAte > B-DPEDI.CanPed THEN DO:
                  MESSAGE 'Se ha detectado un error el el producto' B-DPEDI.codmat SKIP
                      'Los despachos superan a lo cotizado' SKIP
                      'Cant. cotizada:' B-DPEDI.CanPed SKIP
                      'Total pedidos :' B-DPEDI.CanAte SKIP
                      'FIN DEL PROCESO'
                      VIEW-AS ALERT-BOX WARNING.
                  UNDO, RETURN "ADM-ERROR".
              END.
              /* ************************************ */

          END.
      END.
      /* ACTUALIZAMOS FLAG DE LA COTIZACION */
      FOR EACH FacDPedi NO-LOCK WHERE FacDPedi.CodCia = FacCPedi.CodCia
          AND FacDPedi.CodDiv = FacCPedi.CodDiv
          AND FacDPedi.CodDoc = FacCPedi.CodRef
          AND FacDPedi.NroPed = FacCPedi.NroRef:     
          IF (FacDPedi.CanPed - FacDPedi.CanAte) > 0 
          THEN DO:
             I-NRO = 1.
             LEAVE.
          END.
      END.
      /* RHC 22-03-2003 */
      FIND B-CPedi WHERE B-CPedi.CodCia = FacCPedi.CodCia
          AND  B-CPedi.CodDiv = FacCPedi.CodDiv
          AND  B-CPedi.CodDoc = FacCPedi.CodRef
          AND  B-CPedi.NroPed = FacCPedi.NroRef
          EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE B-CPedi THEN DO:
          IF I-NRO = 0 
          THEN ASSIGN B-CPedi.FlgEst = "C".
          ELSE ASSIGN B-CPedi.FlgEst = "P".
      END.
      IF AVAILABLE(B-CPedi) THEN RELEASE B-CPedi.
      IF AVAILABLE(B-DPedi) THEN RELEASE B-DPedi.
  END.
  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


