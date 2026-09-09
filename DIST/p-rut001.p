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
DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pError AS LOG.

DEF TEMP-TABLE T-Ped-Guias
    FIELD codalm LIKE Almcmov.codalm
    FIELD codped LIKE Ccbcdocu.codped
    FIELD nroped LIKE Ccbcdocu.nroped
    FIELD libre_c01 LIKE Ccbcdocu.libre_c01
    FIELD libre_c02 LIKE Ccbcdocu.libre_c02
    FIELD nroguias AS INT
    FIELD nrototal AS INT.

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
         HEIGHT             = 5.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
  DEF BUFFER B-RutaC FOR DI-RutaC.

  {lib/lock-genericov3.i
      &Tabla="B-RUTAC"
      &Condicion="ROWID(B-RutaC) = pRowid"
      &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
      &Accion="RETRY"
      &Mensaje="YES"
      &TipoError="UNDO, RETURN 'ADM-ERROR'"
      }
  ASSIGN
      B-RutaC.FlgEst = "P".    /* Pendiente */

  RUN Bultos-por-GR.

  RUN Bultos-por-OTR.
  
  /* RHC 16.08.2012 REPARTIMOS BULTOS POR GUIAS DE TRANSFERENCIA */
/*   FOR EACH Di-RutaG OF B-RutaC:                                                                   */
/*       Di-RutaG.CodMat = "".                                                                        */
/*       FIND FIRST CcbCBult WHERE CcbCBult.CodCia = B-RutaC.codcia                                  */
/*           AND CcbCBult.CodDoc = "TRA"                                                              */
/*           AND CcbCBult.NroDoc = STRING(Di-RutaG.serref, '999') + STRING(Di-RutaG.nroref, '999999') */
/*           AND CcbCBult.CHR_01 = "P"                                                                */
/*           NO-LOCK NO-ERROR.                                                                        */
/*       IF AVAILABLE CcbCBult THEN Di-RutaG.CodMat = STRING(CcbCBult.Bultos).                        */
/*   END.                                                                                             */

  RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Bultos-por-GR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bultos-por-GR Procedure 
PROCEDURE Bultos-por-GR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE T-Ped-Guias.
  FOR EACH Di-RutaD OF B-RutaC NO-LOCK WHERE Di-RutaD.CodRef = "G/R", 
      FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = B-RutaC.codcia
      AND Ccbcdocu.coddoc = DI-RutaD.CodRef
      AND Ccbcdocu.nrodoc = DI-RutaD.NroRef
      AND Ccbcdocu.coddiv = B-RutaC.CodDiv:    /* OJO: SOLO DEL ALMACEN DE DESPACHO */
      /* acumulamos cantidad de guias por cada ORDEN DE DESPACHO */
      FIND T-Ped-Guias WHERE T-Ped-Guias.libre_c01 = Ccbcdocu.Libre_c01
          AND T-Ped-Guias.libre_c02 = Ccbcdocu.Libre_c02
          NO-ERROR.
      IF NOT AVAILABLE T-Ped-Guias THEN CREATE T-Ped-Guias.
      ASSIGN
          T-Ped-Guias.codped = Ccbcdocu.codped
          T-Ped-Guias.nroped = Ccbcdocu.nroped
          T-Ped-Guias.libre_c01 = Ccbcdocu.Libre_c01    /* O/D */
          T-Ped-Guias.libre_c02 = Ccbcdocu.Libre_c02
          T-Ped-Guias.nroguias = T-Ped-Guias.nroguias + 1.
  END.
  /* contamos cuantas g/r se han generado en la división de despacho */
  /* Guias de remisión están relacionadas */
  /* RHC 24/05/18 Buscamos al menos una G/R facturada pero que no esté 
    en ninguna H/R */
  FOR EACH T-Ped-Guias:
      FOR EACH Ccbcdocu USE-INDEX llave15 NO-LOCK WHERE Ccbcdocu.codcia = B-RutaC.codcia
          AND Ccbcdocu.coddiv = B-RutaC.coddiv
          AND Ccbcdocu.codped = T-Ped-Guias.codped          /* PED */
          AND Ccbcdocu.nroped = T-Ped-Guias.nroped
          AND Ccbcdocu.Libre_c01 = T-Ped-Guias.libre_c01    /* O/D */
          AND Ccbcdocu.Libre_c02 = T-Ped-Guias.libre_c02
          AND Ccbcdocu.coddoc = "G/R"
          AND Ccbcdocu.flgest = "F":
          /* ******************************************************************************** */
          /* RHC 24/05/2018 CASO REPROGRAMACION DE O/D */
          /* La G/R NO Puede estar en otra H/R ya cerrada */
          /* ******************************************************************************** */
          FIND FIRST Di-RutaD WHERE DI-RutaD.CodCia = B-RutaC.CodCia
              AND DI-RutaD.CodDiv = B-RutaC.CodDiv
              AND DI-RutaD.CodDoc = "H/R"
              AND DI-RutaD.CodRef = Ccbcdocu.CodDoc   /* G/R */
              AND DI-RutaD.NroRef = Ccbcdocu.NroDoc
              AND CAN-FIND(FIRST DI-RutaC OF DI-RutaD WHERE DI-RutaC.FlgEst = "C" NO-LOCK)
              NO-LOCK NO-ERROR.
          IF AVAILABLE Di-RutaD THEN NEXT.
          /* ******************************************************************************** */
          /* ******************************************************************************** */
          T-Ped-Guias.nrototal = T-Ped-Guias.nrototal + 1.
          FIND Di-RutaD OF B-RutaC WHERE Di-RutaD.codref = Ccbcdocu.coddoc
              AND Di-RutaD.nroref = Ccbcdocu.nrodoc
              NO-LOCK NO-ERROR.
          IF pError = YES AND NOT AVAILABLE Di-RutaD THEN DO:
              MESSAGE 'Falta Registrar la' Ccbcdocu.coddoc Ccbcdocu.nrodoc SKIP
                  'del' T-Ped-Guias.CodPed T-Ped-Guias.NroPed SKIP
                  'de la' Ccbcdocu.Libre_c01 Ccbcdocu.Libre_c02
                  VIEW-AS ALERT-BOX WARNING.
          END.
      END.
  END.
  /* error */
  FOR EACH T-Ped-Guias WHERE nroguias <> nrototal:
      ASSIGN
          B-RutaC.FlgEst = "X".    /* Faltan registrar G/R */
  END.
  
  DEFINE BUFFER x-faccpedi FOR faccpedi.
  DEFINE VAR x-nro-cotizacion AS CHAR.
  DEFINE VAR x-pedido-anterior AS CHAR.

  /* *************************************** */
  /* RHC 19.06.2012 REPARTIMOS LOS BULTOS POR LAS GUIAS DE REMISION vs ORDENES DE DESPACHO */
  FOR EACH Di-RutaD OF B-RutaC WHERE Di-RutaD.CodRef = "G/R",
      FIRST Ccbcdocu NO-LOCK WHERE Ccbcdocu.codcia = B-RutaC.codcia
      AND Ccbcdocu.coddoc = DI-RutaD.CodRef
      AND Ccbcdocu.nrodoc = DI-RutaD.NroRef,
      FIRST CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Ccbcdocu.codcia
      AND CcbCBult.CodDoc = Ccbcdocu.Libre_C01      /* O/D */
      AND CcbCBult.NroDoc = Ccbcdocu.Libre_C02      
      /*AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */*/
      BREAK BY CcbCBult.CodDoc BY CcbCBult.NroDoc:
      DI-RutaD.Libre_d02 = 0.
      IF FIRST-OF(CcbCBult.CodDoc) OR FIRST-OF(CcbCBult.NroDoc) 
          THEN DI-RutaD.Libre_d02 = CcbCBult.Bultos.

      /* Si la hoja de Ruta esta Confirmada */
      /* Ic - 30Ene2018, este proceso se trae desde la impresion */
      IF B-rutaC.libre_l01 = YES THEN DO:
          /* Pedido Anterior */
          x-nro-cotizacion = "".
          x-pedido-anterior = "".
          /* Ubicar Cotizacion */
          FIND FIRST x-faccpedi WHERE x-faccpedi.codcia = Di-RutaD.codcia AND
                                        x-faccpedi.coddoc = 'PED' AND 
                                        x-faccpedi.nroped = ccbcdocu.nroped NO-LOCK NO-ERROR.
          IF AVAILABLE x-faccpedi THEN x-nro-cotizacion = x-faccpedi.nroref.

          IF x-nro-cotizacion <> "" THEN DO:
              FIND LAST x-faccpedi WHERE x-faccpedi.codcia = Di-RutaD.codcia AND 
                                            x-faccpedi.codcli = ccbcdocu.codcli AND 
                                            x-faccpedi.coddoc = 'PED' AND 
                                            x-faccpedi.nroped < ccbcdocu.nroped AND 
                                            x-faccpedi.codref = 'COT' AND
                                            x-faccpedi.nroref = x-nro-cotizacion NO-LOCK NO-ERROR.
              IF AVAILABLE x-faccpedi THEN x-pedido-anterior = x-faccpedi.nroped.

              IF x-pedido-anterior <> "" THEN DO:
                  ASSIGN di-rutaD.libre_c04 = x-pedido-anterior.
                  /*
                  /* Grabo en DI-RUTAD */
                  x-rowid = ROWID(di-rutaD).
                  FIND FIRST x-di-rutaD WHERE ROWID(x-di-rutad) = x-rowid NO-ERROR.
                  IF AVAILABLE x-di-rutaD THEN ASSIGN x-di-rutaD.libre_c04 = x-pedido-anterior.
                  */
              END.

          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Bultos-por-OTR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Bultos-por-OTR Procedure 
PROCEDURE Bultos-por-OTR :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE T-Ped-Guias.


  FOR EACH Di-RutaG OF B-RutaC,
      FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = Di-RutaG.CodCia
      AND Almcmov.CodAlm = Di-RutaG.CodAlm
      AND Almcmov.TipMov = Di-RutaG.Tipmov
      AND Almcmov.CodMov = Di-RutaG.Codmov
      AND Almcmov.NroSer = Di-RutaG.serref
      AND Almcmov.NroDoc = Di-RutaG.nroref:
      Di-RutaG.CodMat = "".
      CASE TRUE:
          WHEN Almcmov.CodRef = "OTR" THEN DO:
              /* acumulamos cantidad de guias por cada ORDEN DE DESPACHO */
              FIND T-Ped-Guias WHERE T-Ped-Guias.codped = Almcmov.CodRef
                  AND T-Ped-Guias.nroped = Almcmov.NroRef
                  NO-ERROR.
              IF NOT AVAILABLE T-Ped-Guias THEN CREATE T-Ped-Guias.
              ASSIGN
                  T-Ped-Guias.codalm = Almcmov.CodAlm 
                  T-Ped-Guias.codped = Almcmov.CodRef
                  T-Ped-Guias.nroped = Almcmov.Nroref
                  T-Ped-Guias.nroguias = T-Ped-Guias.nroguias + 1.
          END.
          OTHERWISE DO:
              FIND FIRST CcbCBult WHERE CcbCBult.CodCia = B-RutaC.codcia
                  AND CcbCBult.CodDoc = "TRA"
                  AND CcbCBult.NroDoc = STRING(Di-RutaG.serref, '999') + STRING(Di-RutaG.nroref, '9999999')
                  AND CcbCBult.CHR_01 = "P"
                  NO-LOCK NO-ERROR.
              IF AVAILABLE CcbCBult THEN Di-RutaG.CodMat = STRING(CcbCBult.Bultos).
          END.
      END CASE.
  END.
  /* contamos cuantas g/r se han generado en la división de despacho */
  FOR EACH T-Ped-Guias:
      FOR EACH Almcmov NO-LOCK WHERE Almcmov.codcia = B-RutaC.codcia
          AND Almcmov.codalm = T-Ped-Guias.codalm
          AND Almcmov.codref = T-Ped-Guias.codped 
          AND Almcmov.nroref = T-Ped-Guias.nroped
          AND (Almcmov.tipmov = 'S' AND Almcmov.codmov = 03)     /* Ic - 27Jun2019, (g/r se han generado en la división de despacho), significa SALIDAS */
          AND LOOKUP(Almcmov.flgest, "A,R") = 0:    /* NO ANULADOS, NO REPROGRAMADOS */
          T-Ped-Guias.nrototal = T-Ped-Guias.nrototal + 1.
          FIND Di-RutaG OF B-RutaC WHERE Di-RutaG.serref = Almcmov.nroser
              AND Di-RutaG.nroref = Almcmov.nrodoc
              NO-LOCK NO-ERROR.
          IF pError = YES AND NOT AVAILABLE Di-RutaG THEN DO:
              MESSAGE 'Falta Registrar la G/R' Almcmov.nroser Almcmov.nrodoc SKIP
                  'de la' T-Ped-Guias.CodPed T-Ped-Guias.NroPed
                  VIEW-AS ALERT-BOX WARNING.
          END.
      END.
  END.
  /* error */
  FOR EACH T-Ped-Guias WHERE nroguias <> nrototal:
      ASSIGN
          B-RutaC.FlgEst = "X".    /* Faltan registrar G/R */
  END.
  /* *************************************** */
  /* RHC 19.06.2012 REPARTIMOS LOS BULTOS POR LAS GUIAS DE REMISION vs ORDENES DE DESPACHO */
  FOR EACH Di-RutaG OF B-RutaC,
      FIRST Almcmov NO-LOCK WHERE Almcmov.CodCia = Di-RutaG.CodCia
      AND Almcmov.CodAlm = Di-RutaG.CodAlm
      AND Almcmov.TipMov = Di-RutaG.Tipmov
      AND Almcmov.CodMov = Di-RutaG.Codmov
      AND Almcmov.NroSer = Di-RutaG.serref
      AND Almcmov.NroDoc = Di-RutaG.nroref,
      FIRST CcbCBult NO-LOCK WHERE CcbCBult.CodCia = Almcmov.codcia
      AND CcbCBult.CodDoc = Almcmov.codref      
      AND CcbCBult.NroDoc = Almcmov.nroref      
      AND CcbCBult.CHR_01 = "P"                     /* H/R Aún NO cerrada */
      BREAK BY CcbCBult.CodDoc BY CcbCBult.NroDoc:
      Di-RutaG.CodMat = ''.
      IF FIRST-OF(CcbCBult.CodDoc) OR FIRST-OF(CcbCBult.NroDoc) 
          THEN Di-RutaG.CodMat = STRING(CcbCBult.Bultos).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

