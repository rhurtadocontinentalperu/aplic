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

/*
RUTINA GENERAL PARA VALIDAR O/D PARA CARGAR LAS PHR
*/

  /* Está en una PHR en trámite => NO va */
  FIND FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
        DI-RutaD.CodDiv = s-CodDiv AND
        DI-RutaD.CodDoc = "PHR" AND
        DI-RutaD.CodRef = Faccpedi.CodDoc AND
        DI-RutaD.NroRef = Faccpedi.NroPed AND
        CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst BEGINS "P" NO-LOCK)
        NO-LOCK NO-ERROR.
  IF AVAILABLE DI-RutaD THEN RETURN 'ADM-ERROR'.

  /* Si tiene una reprogramación por aprobar => No va  */
  FIND FIRST Almcdocu WHERE AlmCDocu.CodCia = s-CodCia AND
      AlmCDocu.CodLlave = s-CodDiv AND
      AlmCDocu.CodDoc = Faccpedi.coddoc AND 
      AlmCDocu.NroDoc = Faccpedi.nroped AND
      AlmCDocu.FlgEst = "P" NO-LOCK NO-ERROR.
  IF AVAILABLE Almcdocu THEN RETURN 'ADM-ERROR'.

  /* Si ya fue entregado o tiene una devolución parcial NO va */
  FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
      AND CcbCDocu.CodPed = Faccpedi.codref       /* PED */
      AND CcbCDocu.NroPed = Faccpedi.nroref
      AND Ccbcdocu.Libre_c01 = Faccpedi.coddoc    /* O/D */
      AND Ccbcdocu.Libre_c02 = Faccpedi.nroped
      AND Ccbcdocu.FlgEst <> "A":
      IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
      FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
          AND B-RutaD.CodDiv = s-CodDiv
          AND B-RutaD.CodDoc = "H/R"
          AND B-RutaD.CodRef = Ccbcdocu.coddoc
          AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
          FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst = 'C':
          IF B-RutaD.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
          IF B-RutaD.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */
          /* Verificamos que haya pasado por PHR */
          IF NOT CAN-FIND(FIRST DI-RutaD WHERE DI-RutaD.CodCia = s-CodCia AND
                          DI-RutaD.CodDiv = s-CodDiv AND
                          DI-RutaD.CodDoc = "PHR" AND
                          DI-RutaD.CodRef = Faccpedi.CodDoc AND
                          DI-RutaD.NroRef = Faccpedi.NroPed AND
                          CAN-FIND(DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst = "C" NO-LOCK)
                          NO-LOCK)
              THEN RETURN 'ADM-ERROR'.
      END.
  END.
  FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
      Almcmov.CodRef = Faccpedi.CodDoc AND 
      Almcmov.NroRef = Faccpedi.NroPed AND
      Almcmov.FlgEst <> 'A':
      FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
          AND B-RutaG.CodDiv = s-CodDiv
          AND B-RutaG.CodDoc = "H/R"
          AND B-RutaG.CodAlm = Almcmov.CodAlm
          AND B-RutaG.Tipmov = Almcmov.TipMov
          AND B-RutaG.Codmov = Almcmov.CodMov
          AND B-RutaG.SerRef = Almcmov.NroSer
          AND B-RutaG.NroRef = Almcmov.NroDoc,
          FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst = 'C':
          IF B-RutaG.FlgEst = "C" THEN RETURN 'ADM-ERROR'.  /* Entregado */
          IF B-RutaG.FlgEst = "D" THEN RETURN 'ADM-ERROR'.  /* Devolución Parcial */
      END.
  END.
  /* Si está en una H/R en trámite => No va */
  FOR EACH Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = s-codcia
      AND CcbCDocu.CodPed = Faccpedi.codref       /* PED */
      AND CcbCDocu.NroPed = Faccpedi.nroref
      AND Ccbcdocu.Libre_c01 = Faccpedi.coddoc    /* O/D */
      AND Ccbcdocu.Libre_c02 = Faccpedi.nroped
      AND Ccbcdocu.FlgEst <> "A":
      IF NOT (Ccbcdocu.coddiv = s-coddiv AND Ccbcdocu.coddoc = "G/R") THEN NEXT.
      FOR EACH B-RutaD NO-LOCK WHERE B-RutaD.CodCia = s-codcia
          AND B-RutaD.CodDiv = s-CodDiv
          AND B-RutaD.CodDoc = "H/R"
          AND B-RutaD.CodRef = Ccbcdocu.coddoc
          AND B-RutaD.NroRef = Ccbcdocu.nrodoc,
          FIRST B-RutaC OF B-RutaD NO-LOCK WHERE B-RutaC.FlgEst BEGINS 'P':
          RETURN 'ADM-ERROR'.
      END.
  END.
  FOR EACH Almcmov NO-LOCK WHERE Almcmov.CodCia = s-CodCia AND 
      Almcmov.CodRef = Faccpedi.CodDoc AND 
      Almcmov.NroRef = Faccpedi.NroPed AND
      Almcmov.FlgEst <> 'A':
      FOR EACH B-RutaG NO-LOCK WHERE B-RutaG.CodCia = s-codcia
          AND B-RutaG.CodDiv = s-CodDiv
          AND B-RutaG.CodDoc = "H/R"
          AND B-RutaG.CodAlm = Almcmov.CodAlm
          AND B-RutaG.Tipmov = Almcmov.TipMov
          AND B-RutaG.Codmov = Almcmov.CodMov
          AND B-RutaG.SerRef = Almcmov.NroSer
          AND B-RutaG.NroRef = Almcmov.NroDoc,
          FIRST B-RutaC OF B-RutaG NO-LOCK WHERE B-RutaC.FlgEst BEGINS 'P':
          RETURN 'ADM-ERROR'.
      END.
  END.
  RETURN 'OK'.

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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


