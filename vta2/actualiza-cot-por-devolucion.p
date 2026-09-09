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

  DEFINE BUFFER B-DPEDI FOR FacDPedi.
  DEFINE BUFFER B-CPEDI FOR FacCPedi.
  DEFINE BUFFER B-CDOCU FOR Ccbcdocu.
  DEFINE BUFFER B-DDOCU FOR Ccbddocu.

  /* Buscamos N/C */
  FIND B-CDOCU WHERE ROWID(B-CDOCU) = pRowid NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CDOCU THEN RETURN "ADM-ERROR".
  IF LOOKUP(B-CDOCU.CodRef, 'FAC,BOL') = 0 THEN RETURN 'OK'.
  /* Buscamos FAC o BOL */
  FIND Ccbcdocu WHERE Ccbcdocu.codcia = B-CDOCU.codcia
      AND Ccbcdocu.coddoc = B-CDOCU.codref
      AND Ccbcdocu.nrodoc = B-CDOCU.nroref
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Ccbcdocu THEN RETURN "OK".
  /* Buscamos PED: Debe ser por CREDITOS */
  IF Ccbcdocu.CodPed <> "PED" THEN RETURN "OK".
  FIND Faccpedi WHERE Faccpedi.codcia = Ccbcdocu.codcia 
      AND Faccpedi.coddiv = Ccbcdocu.divori
      AND Faccpedi.coddoc = Ccbcdocu.codped     /* PED */
      AND Faccpedi.nroped = Ccbcdocu.nroped
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Faccpedi THEN RETURN "OK".
  /* Buscamos COT */
  FIND B-CPEDI WHERE B-CPEDI.codcia = Faccpedi.codcia
      AND B-CPEDI.coddiv = Faccpedi.coddiv
      AND B-CPEDI.coddoc = Faccpedi.codref      /* COT */
      AND B-CPEDI.nroped = Faccpedi.nroref
      NO-LOCK NO-ERROR.
  IF NOT AVAILABLE B-CPEDI THEN RETURN "OK".

  RLOOP:
  DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN "ADM-ERROR".
      /* RHC 13.01.2012 NO PROMOCIONES */
      FOR EACH B-DDOCU OF B-CDOCU NO-LOCK:
          FIND FIRST B-DPedi OF B-CPEDI WHERE B-DPedi.CodMat = B-DDOCU.CodMat 
              EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
          IF ERROR-STATUS:ERROR = YES THEN DO:
              IF LOCKED(B-DPEDI) THEN DO:
                  MESSAGE 'Registro:' B-CPEDI.coddoc B-CPEDI.nroped B-DDOCU.CodMat 
                      'en uso por otro usuario' SKIP
                      'Proceso Abortado' VIEW-AS ALERT-BOX ERROR.
                  UNDO RLOOP, RETURN 'ADM-ERROR'.
              END.
              ELSE DO:
                  /* Si no está en la cotización debe ser un promoción */
                  RETURN "OK".
              END.
          END.
          ASSIGN B-DPedi.CanAte = B-DPedi.CanAte + ( B-DDOCU.CanDes * pFactor ).
      END.
      /* RHC 22-03-2003 */
      FIND FIRST B-DPEDI OF B-CPEDI WHERE (B-DPEDI.CanPed - B-DPEDI.CanAte) > 0
          NO-LOCK NO-ERROR.
      IF AVAILABLE B-DPEDI 
      THEN B-CPEDI.FlgEst = "P".
      ELSE B-CPEDI.FlgEst = "C". 
  END.
  RELEASE B-CPEDI.
  RELEASE B-DPEDI.
  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


