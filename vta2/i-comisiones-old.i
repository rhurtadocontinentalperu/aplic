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
  
  /* PRIMERO: LOS COMPROBANTES DE VENTAS */
/*   DISPLAY 'Calculando Comisiones' @ x-mensaje WITH FRAME {&FRAME-NAME}. */

  DEF VAR x-FchCan AS DATE NO-UNDO.
  DEF VAR x-ImpTot AS DEC NO-UNDO.

  DEF VAR x-Signo  AS INT NO-UNDO.
  DEF VAR x-FchDoc AS DATE NO-UNDO.
  DEF VAR x-Contador AS INT NO-UNDO.

  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
      AND GN-DIVI.coddiv = x-CodDiv,
      EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.CodDiv = gn-divi.coddiv
      AND Ventas_Cabecera.DateKey >= x-FchDoc-1
      AND Ventas_Cabecera.DateKey <= x-FchDoc-2:
      IF NOT LOOKUP(Ventas_Cabecera.CodDoc, 'FAC,BOL,TCK,N/C') > 0 THEN NEXT.
      x-Contador = x-Contador + 1.
/*       IF x-Contador MODULO 1000 = 0 THEN                                        */
/*           DISPLAY Ventas_Cabecera.CodDiv + '*' +                                */
/*           Ventas_Cabecera.coddoc + ' ' +                                        */
/*           Ventas_Cabecera.nrodoc + ' ' +                                        */
/*           STRING(Ventas_Cabecera.DateKey) @ x-mensaje WITH FRAME {&FRAME-NAME}. */
      CREATE T-CDOC.
      BUFFER-COPY Ventas_Cabecera
          TO T-CDOC
          ASSIGN
          T-CDOC.codcia = s-codcia
          T-CDOC.coddiv = Ventas_Cabecera.coddiv
          T-CDOC.coddoc = Ventas_Cabecera.coddoc
          T-CDOC.nrodoc = Ventas_Cabecera.nrodoc
          T-CDOC.fchdoc = Ventas_Cabecera.DateKey
          T-CDOC.codven = Ventas_Cabecera.codven
          T-CDOC.fmapgo = Ventas_Cabecera.fmapgo
          T-CDOC.imptot2Old = 0.
      ASSIGN
          x-Signo  = 1
          x-FchDoc = Ventas_Cabecera.DateKey.
      /*IF Ventas_Cabecera.CodDoc = 'N/C' THEN x-Signo = -1.*/
      DETALLE:
      FOR EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK,
          FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
          AND Almmmatg.codmat = Ventas_Detalle.codmat :
          IF Ventas_Detalle.ImpNacSIGV = ? THEN NEXT.
          IF Almmmatg.codfam = '009' THEN NEXT.
          CREATE T-DDOC.
          ASSIGN
              T-DDOC.codcia = s-codcia
              T-DDOC.coddoc = T-CDOC.coddoc
              T-DDOC.nrodoc = T-CDOC.nrodoc
              T-DDOC.coddiv = T-CDOC.coddiv
              T-DDOC.codven = T-CDOC.codven
              T-DDOC.codmat = Ventas_Detalle.codmat
              T-DDOC.undvta = Almmmatg.undstk
              T-DDOC.implin = Ventas_Detalle.ImpNacSIGV.
          /* Ic - 14Nov2016 */
          ASSIGN t-ddoc.canalvtaproc = gn-divi.canalventa
                t-ddoc.canalvtadiv = gn-divi.canalventa.

          /* comisiones por linea */
          FIND LAST VtaTabla WHERE VtaTabla.codcia = s-codcia
              AND VtaTabla.Tabla = "CAMPAÑAS"
              AND x-FchDoc >= VtaTabla.Rango_Fecha[1]
              AND x-FchDoc <= VtaTabla.Rango_Fecha[2]
              NO-LOCK NO-ERROR.
          ASSIGN
              t-ddoc.Flg_Factor = Almmmatg.TipArt
              T-DDOC.ImpComisOld = 0.
          /* comisiones por rotacion */
          ROTACION:
          DO:
              IF Almmmatg.Clase <> 'X' AND (Almmmatg.Libre_f01 = ? OR Almmmatg.Libre_f01 >= TODAY) THEN DO:
                  FIND PorComi WHERE PorComi.CodCia = s-codcia AND PorComi.Catego = Almmmatg.Clase NO-LOCK NO-ERROR.
                  IF AVAILABLE PorComi THEN DO:
                      ASSIGN
                          T-DDOC.ImpComisOld = x-Signo * t-ddoc.implin * PorComi.Porcom / 100
                          T-DDOC.PorComisOld = PorComi.Porcom
                          t-ddoc.Flg_Factor = "*".
                      LEAVE ROTACION.
                  END.
              END.
              FIND FacTabla WHERE FacTabla.codcia = s-codcia
                  AND FacTabla.Tabla = 'CV'
                  AND FacTabla.Codigo = TRIM(Almmmatg.codfam) + t-cdoc.coddiv
                  NO-LOCK NO-ERROR.
              IF AVAILABLE FacTabla THEN DO:
                  IF AVAILABLE VtaTabla
                      THEN ASSIGN
                              T-DDOC.ImpComisOld = x-Signo * t-ddoc.implin * FacTabla.Valor[1] / 100
                              T-DDOC.PorComisOld = FacTabla.Valor[1].
                      ELSE ASSIGN
                              T-DDOC.ImpComisOld = x-Signo * t-ddoc.implin * FacTabla.Valor[2] / 100
                              T-DDOC.PorComisOld = FacTabla.Valor[2].
              END.
          END.
          ASSIGN
              t-ddoc.implin = x-Signo * t-ddoc.implin.
      END.
  END.

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
         HEIGHT             = 3.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


