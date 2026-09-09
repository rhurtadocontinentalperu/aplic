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
/* DISTRIBUYE LA CANTIDAD PEDIDA POR CADA ALMACEN VALIDO DE DESCARGA (s-codalm) */
/* El puntero está en el registro de PEDI-1 (resumen por producto) */

/* PRIMERA PASADA: CARGAMOS STOCK DISPONIBLE POR ALMACEN EN EL ORDEN DE LOS ALMACENES VALIDOS */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  DEF VAR i        AS INT NO-UNDO.
  DEF VAR f-canPed AS DEC NO-UNDO.
  DEF VAR x-CodAlm AS CHAR NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.
  DEF VAR s-StkComprometido AS DEC NO-UNDO.
  DEF VAR s-StkDis AS DEC NO-UNDO.
  DEF VAR I-NPEDI  AS INT NO-UNDO.

  /* BARREMOS LOS ALMACENES VALIDOS Y DECIDIMOS CUAL ES EL MEJOR DESPACHO */
  f-Factor = PEDI-1.Factor.
  t-AlmDes = ''.
  t-CanPed = 0.
  ALMACENES:
  DO i = 1 TO NUM-ENTRIES(s-CodAlm):
      ASSIGN
          F-CANPED = PEDI-1.CanPed
          x-CodAlm = ENTRY(i, s-CodAlm).
      /* FILTROS */
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
          AND Almmmate.codmat = PEDI-1.CodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE 'Producto' PEDI-1.codmat 'NO asignado al almacén' x-CodAlm
              VIEW-AS ALERT-BOX WARNING.
          NEXT ALMACENES.
      END.
      x-StkAct = Almmmate.StkAct.
      RUN vtagn/Stock-Comprometido (PEDI-1.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN NEXT ALMACENES.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
      END.
      f-CanPed = f-CanPed * f-Factor.
      /* EMPAQUE OTROS */
      IF s-FlgEmpaque = YES THEN DO:
          IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
      END.
      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
      IF f-CanPed <= 0 THEN NEXT ALMACENES.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
  END.
  IF t-CanPed > 0 THEN DO:
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY PEDI-1 TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = s-coddiv
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = t-CanPed    /* << OJO << */
              PEDI.CanAte = 0.
      ASSIGN
          PEDI.Libre_d01 = (PEDI-1.CanPed - PEDI-1.CanAte)
          PEDI.Libre_d02 = t-CanPed
          PEDI.Libre_c01 = '*'.
      /* PRODUCTOS EN REMATE
         Si se esta descargando del almacén de remate entonces hay que recalcular
         nuevamente el precio unitario.
         Se supone que un producto de remate solo existe en el almacén de remates 
         */
      FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = t-AlmDes NO-LOCK.
      IF Almacen.Campo-C[3] = 'Si' THEN DO:     /* Almacen de Remate */
          RUN vta2/PrecioContaMayorista (s-CodCia,
                    s-CodDiv,
                    s-CodCli,
                    s-CodMon,
                    s-TpoCmb,
                    OUTPUT f-Factor,
                    PEDI-1.CodMat,
                    s-FlgSit,
                    PEDI-1.UndVta,
                    PEDI.CanPed,
                    4,
                    t-AlmDes,
                    OUTPUT f-PreBas,
                    OUTPUT f-PreVta,
                    OUTPUT f-Dsctos,
                    OUTPUT y-Dsctos).
          ASSIGN 
              PEDI-1.PreUni = f-PreVta
              PEDI-1.PorDto = F-Dsctos
              PEDI-1.PreBas = F-PreBas 
              PEDI-1.Por_Dsctos[3] = y-Dsctos
              PEDI.PreUni = PEDI-1.PreUni
              PEDI.PorDto = PEDI-1.PorDto 
              PEDI.Prebas = PEDI-1.PreBas
              PEDI.Por_Dsctos[3] = PEDI-1.Por_Dsctos[3].
      END.
      /* FIND ALMACEN REMATE ********************************************************************* */
      ASSIGN
          PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                        ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                        ( 1 - PEDI.Por_Dsctos[3] / 100 ).
      IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
      THEN PEDI.ImpDto = 0.
      ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
      ASSIGN
          PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
          PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
      IF PEDI.AftIsc 
          THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      ELSE PEDI.ImpIsc = 0.
      IF PEDI.AftIgv 
          THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
      ELSE PEDI.ImpIgv = 0.
      /* FIN DE CARGA PRIMERA PASADA */
  END.

  /* SEGUNDA PASADA: TRATAMOS DE DESCARGAR DE LOS DEMAS ALMACENES */
  /* BARREMOS EL RESTO DE ALMACENES */
  f-Factor = PEDI-1.Factor.
  t-AlmDes = ''.
  t-CanPed = 0.
  FIND FIRST PEDI WHERE PEDI.CodMat = PEDI-1.CodMat NO-LOCK NO-ERROR.
  IF AVAILABLE PEDI 
      THEN ASSIGN
                t-AlmDes = PEDI.AlmDes.
  ALMACENES:
  DO i = 1 TO NUM-ENTRIES(s-CodAlm):
      t-CanPed = 0.
      FOR EACH PEDI WHERE PEDI.CodMat = PEDI-1.CodMat.
          t-CanPed = t-CanPed + PEDI.CanPed.
      END.
      ASSIGN
          F-CANPED = PEDI-1.CanPed - t-CanPed
          x-CodAlm = ENTRY(i, s-CodAlm).
      /* FILTROS */
      IF F-CANPED <= 0 THEN LEAVE ALMACENES.
      IF t-AlmDes = x-CodAlm THEN NEXT ALMACENES.
      FIND Almmmate WHERE Almmmate.codcia = s-codcia
          AND Almmmate.codalm = x-CodAlm  /* *** OJO *** */
          AND Almmmate.codmat = PEDI-1.CodMat
          NO-LOCK NO-ERROR.
      IF NOT AVAILABLE Almmmate THEN DO:
          MESSAGE 'Producto' PEDI-1.codmat 'NO asignado al almacén' x-CodAlm
              VIEW-AS ALERT-BOX WARNING.
          NEXT ALMACENES.
      END.
      x-StkAct = Almmmate.StkAct.
      RUN vtagn/Stock-Comprometido (PEDI-1.CodMat, x-CodAlm, OUTPUT s-StkComprometido).
      s-StkDis = x-StkAct - s-StkComprometido.
      IF s-StkDis <= 0 THEN NEXT ALMACENES.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF s-StkDis < x-CanPed THEN DO:
          f-CanPed = ((S-STKDIS - (S-STKDIS MODULO f-Factor)) / f-Factor).
      END.
      f-CanPed = f-CanPed * f-Factor.
      /* EMPAQUE OTROS */
      IF s-FlgEmpaque = YES THEN DO:
          IF Almmmatg.DEC__03 > 0 THEN f-CanPed = (TRUNCATE((f-CanPed / Almmmatg.DEC__03),0) * Almmmatg.DEC__03).
      END.
      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).
      IF f-CanPed <= 0 THEN NEXT ALMACENES.
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY PEDI-1 TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = s-coddiv
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = x-CodAlm
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = f-CanPed
              PEDI.CanAte = 0.
      ASSIGN
          PEDI.Libre_d01 = (PEDI-1.CanPed - PEDI-1.CanAte)
          PEDI.Libre_d02 = f-CanPed
          PEDI.Libre_c01 = '*'.
      IF PEDI.CanPed <> PEDI-1.CanPed THEN DO:
          ASSIGN
              PEDI.ImpLin = PEDI.CanPed * PEDI.PreUni * 
                            ( 1 - PEDI.Por_Dsctos[1] / 100 ) *
                            ( 1 - PEDI.Por_Dsctos[2] / 100 ) *
                            ( 1 - PEDI.Por_Dsctos[3] / 100 ).
          IF PEDI.Por_Dsctos[1] = 0 AND PEDI.Por_Dsctos[2] = 0 AND PEDI.Por_Dsctos[3] = 0 
          THEN PEDI.ImpDto = 0.
          ELSE PEDI.ImpDto = PEDI.CanPed * PEDI.PreUni - PEDI.ImpLin.
          ASSIGN
              PEDI.ImpLin = ROUND(PEDI.ImpLin, 2)
              PEDI.ImpDto = ROUND(PEDI.ImpDto, 2).
          IF PEDI.AftIsc 
              THEN PEDI.ImpIsc = ROUND(PEDI.PreBas * PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
          IF PEDI.AftIgv 
              THEN PEDI.ImpIgv = PEDI.ImpLin - ROUND( PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
      END.
      /* FIN DE CARGA */
  END.

  /* RESUMEN POR PRODUCTO */
  ASSIGN
      PEDI-1.CanPed = 0
      PEDI-1.ImpLin = 0
      PEDI-1.ImpDto = 0
      PEDI-1.ImpIgv = 0.
  FOR EACH PEDI WHERE PEDI.CodMat = PEDI-1.CodMat:
      ASSIGN
          PEDI-1.CanPed = PEDI-1.CanPed + PEDI.CanPed
          PEDI-1.ImpLin = PEDI-1.ImpLin + PEDI.ImpLin
          PEDI-1.ImpDto = PEDI-1.ImpDto + PEDI.ImpDto
          PEDI-1.ImpIgv = PEDI-1.ImpIgv + PEDI.ImpIgv.
  END.
  /* RESUMEN POR SEDE DE DESPACHO */
  EMPTY TEMP-TABLE PEDI-2.
  FOR EACH PEDI, FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = PEDI.AlmDes:
      FIND PEDI-2 WHERE PEDI-2.coddiv = Almacen.coddiv NO-ERROR.
      IF NOT AVAILABLE PEDI-2 THEN DO:
          CREATE PEDI-2.
          BUFFER-COPY PEDI
              EXCEPT PEDI.CodDiv PEDI.ImpLin
              TO PEDI-2
              ASSIGN PEDI-2.coddiv = Almacen.coddiv.
      END.
      ASSIGN
          PEDI-2.ImpLin = PEDI-2.ImpLin + PEDI.ImpLin.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


