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
         HEIGHT             = 4.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
/* RECALCULA LA CANTIDAD PEDIDA Y VUELVE A CALCULAR EL PRECIO UNITARIO Y LOS TOTALES */
/* El puntero debe estar en PEDI-1 */

  /* RESUMEN POR PRODUCTO */
  ASSIGN
      PEDI-1.CanPed = 0
      PEDI-1.ImpLin = 0
      PEDI-1.ImpDto = 0
      PEDI-1.ImpIgv = 0
      PEDI-1.ImpIsc = 0.
  FOR EACH B-PEDI WHERE B-PEDI.codmat = PEDI-1.codmat:
      ASSIGN
          PEDI-1.CanPed = PEDI-1.CanPed + B-PEDI.CanPed
          PEDI-1.ImpLin = PEDI-1.ImpLin + B-PEDI.ImpLin
          PEDI-1.ImpDto = PEDI-1.ImpDto + B-PEDI.ImpDto
          PEDI-1.ImpIgv = PEDI-1.ImpIgv + B-PEDI.ImpIgv
          PEDI-1.ImpIsc = PEDI-1.ImpIsc + B-PEDI.ImpIsc.
  END.
  /* RECALCULAR IMPORTES */
  FIND FIRST B-PEDI WHERE B-PEDI.CodMat = PEDI-1.CodMat NO-LOCK.
  /* ***************************  Main Block  *************************** */
  RUN vta2/PrecioContaMayorista (s-CodCia,
                    s-CodDiv,
                    s-CodCli,
                    s-CodMon,
                    s-TpoCmb,
                    OUTPUT f-Factor,
                    PEDI-1.CodMat,
                    s-FlgSit,
                    PEDI-1.UndVta,
                    PEDI-1.CanPed,
                    4,
                    B-PEDI.AlmDes,
                    OUTPUT f-PreBas,
                    OUTPUT f-PreVta,
                    OUTPUT f-Dsctos,
                    OUTPUT y-Dsctos).
  ASSIGN 
    PEDI-1.PreUni = f-PreVta
    PEDI-1.PorDto = F-Dsctos
    PEDI-1.PreBas = F-PreBas 
    PEDI-1.Por_Dsctos[3] = y-Dsctos.
  ASSIGN
      PEDI-1.ImpLin = ROUND ( PEDI-1.CanPed * PEDI-1.PreUni * 
                    ( 1 - PEDI-1.Por_Dsctos[1] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[2] / 100 ) *
                    ( 1 - PEDI-1.Por_Dsctos[3] / 100 ), 2 ).
  IF PEDI-1.Por_Dsctos[1] = 0 AND PEDI-1.Por_Dsctos[2] = 0 AND PEDI-1.Por_Dsctos[3] = 0 
      THEN PEDI-1.ImpDto = 0.
      ELSE PEDI-1.ImpDto = PEDI-1.CanPed * PEDI-1.PreUni - PEDI-1.ImpLin.
  ASSIGN
      PEDI-1.ImpLin = ROUND(PEDI-1.ImpLin, 2)
      PEDI-1.ImpDto = ROUND(PEDI-1.ImpDto, 2).
  IF PEDI-1.AftIsc 
  THEN PEDI-1.ImpIsc = ROUND(PEDI-1.PreBas * PEDI-1.CanPed * (Almmmatg.PorIsc / 100),4).
  ELSE PEDI-1.ImpIsc = 0.
  IF PEDI-1.AftIgv 
  THEN PEDI-1.ImpIgv = PEDI-1.ImpLin - ROUND(PEDI-1.ImpLin  / (1 + (s-PorIgv / 100)),4).
  ELSE PEDI-1.ImpIgv = 0.

  FOR EACH B-PEDI WHERE B-PEDI.CodMat = PEDI-1.CodMat:
      ASSIGN
          B-PEDI.PreUni = PEDI-1.PreUni
          B-PEDI.PorDto = PEDI-1.PorDto
          B-PEDI.PreBas = PEDI-1.PreBas
          B-PEDI.Por_Dsctos[1] = PEDI-1.Por_Dsctos[1]
          B-PEDI.Por_Dsctos[2] = PEDI-1.Por_Dsctos[2]
          B-PEDI.Por_Dsctos[3] = PEDI-1.Por_Dsctos[3].
      ASSIGN
          B-PEDI.ImpLin = ROUND ( B-PEDI.CanPed * B-PEDI.PreUni * 
                            ( 1 - B-PEDI.Por_Dsctos[1] / 100 ) *
                            ( 1 - B-PEDI.Por_Dsctos[2] / 100 ) *
                            ( 1 - B-PEDI.Por_Dsctos[3] / 100 ), 2 ).
      IF B-PEDI.Por_Dsctos[1] = 0 AND B-PEDI.Por_Dsctos[2] = 0 AND B-PEDI.Por_Dsctos[3] = 0 
          THEN B-PEDI.ImpDto = 0.
      ELSE B-PEDI.ImpDto = B-PEDI.CanPed * B-PEDI.PreUni - B-PEDI.ImpLin.
      ASSIGN
          B-PEDI.ImpLin = ROUND(B-PEDI.ImpLin, 2)
          B-PEDI.ImpDto = ROUND(B-PEDI.ImpDto, 2).
      IF B-PEDI.AftIsc 
          THEN B-PEDI.ImpIsc = ROUND(B-PEDI.PreBas * B-PEDI.CanPed * (Almmmatg.PorIsc / 100),4).
      IF B-PEDI.AftIgv 
          THEN B-PEDI.ImpIgv = B-PEDI.ImpLin - ROUND( B-PEDI.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
  END.
  /* FIN DE RECALCULO DE IMPORTES */

  /* RESUMEN POR SEDE DE DESPACHO */
  EMPTY TEMP-TABLE PEDI-2.
  /* RESUMEN POR SEDE DE DESPACHO */
  FOR EACH B-PEDI, FIRST Almacen NO-LOCK WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-PEDI.AlmDes:
      FIND FIRST PEDI-2 WHERE PEDI-2.coddiv = Almacen.coddiv NO-ERROR.
      IF NOT AVAILABLE PEDI-2 THEN DO:
          CREATE PEDI-2.
          BUFFER-COPY B-PEDI
              EXCEPT B-PEDI.CodDiv B-PEDI.ImpLin
              TO PEDI-2
              ASSIGN PEDI-2.CodDiv = Almacen.coddiv.
      END.
      ASSIGN
          PEDI-2.ImpLin = PEDI-2.ImpLin + B-PEDI.ImpLin.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


