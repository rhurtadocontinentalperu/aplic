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

  DEF VAR x-FchCan AS DATE NO-UNDO.
  DEF VAR x-ImpTot AS DEC NO-UNDO.

  /*DEF VAR x-Signo  AS INT NO-UNDO.*/
  DEF VAR x-FchDoc AS DATE NO-UNDO.

  DEF VAR x-Utilidad AS DEC NO-UNDO.
  DEF VAR x-MargenUtil AS DEC NO-UNDO.
  DEF VAR x-CtoLis AS DEC NO-UNDO.
  DEF VAR x-PreUni AS DEC NO-UNDO.
  DEF VAR x-Campana AS LOG NO-UNDO.
  DEF VAR x-TotDias AS DEC NO-UNDO.
  DEF VAR x-PorComi AS DEC DECIMALS 4 NO-UNDO.
  DEF VAR x-Contador AS INT NO-UNDO.
  

  FOR EACH gn-divi NO-LOCK WHERE gn-divi.codcia = s-codcia
      AND GN-DIVI.coddiv = x-CodDiv,
      EACH Ventas_Cabecera NO-LOCK WHERE Ventas_Cabecera.CodDiv = gn-divi.coddiv
      AND Ventas_Cabecera.DateKey >= x-FchDoc-1
      AND Ventas_Cabecera.DateKey <= x-FchDoc-2:
      IF NOT LOOKUP(Ventas_Cabecera.CodDoc, 'FAC,BOL,TCK,N/C') > 0 THEN NEXT.
      x-Contador = x-Contador + 1.
/*       IF x-Contador MODULO 1000 = 0 THEN                                        */
/*           DISPLAY Ventas_Cabecera.CodDiv + ' ' +                                */
/*           Ventas_Cabecera.coddoc + ' ' +                                        */
/*           Ventas_Cabecera.nrodoc + ' ' +                                        */
/*           STRING(Ventas_Cabecera.DateKey) @ x-mensaje WITH FRAME {&FRAME-NAME}. */
      FIND FIRST T-CDOC WHERE T-CDOC.codcia = s-codcia
          AND T-CDOC.coddoc = Ventas_Cabecera.coddoc
          AND T-CDOC.nrodoc = Ventas_Cabecera.nrodoc
          AND T-CDOC.codven = Ventas_Cabecera.codven
          NO-ERROR.
      IF NOT AVAILABLE T-CDOC THEN CREATE T-CDOC.
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
          T-CDOC.imptot2 = 0.
      ASSIGN
          /*x-Signo  = 1*/
          x-FchDoc = Ventas_Cabecera.DateKey
          x-Campana = NO
          x-TotDias = 0.
      FIND LAST VtaTabla WHERE VtaTabla.codcia = s-codcia
              AND VtaTabla.Tabla = "CAMPAÑAS"
              AND x-FchDoc >= VtaTabla.Rango_Fecha[1]
              AND x-FchDoc <= VtaTabla.Rango_Fecha[2]
          NO-LOCK NO-ERROR.
      IF AVAILABLE VtaTabla THEN x-Campana = YES.
      FIND gn-convt WHERE gn-ConVt.Codig =  Ventas_Cabecera.FmaPgo NO-LOCK NO-ERROR.
      IF AVAILABLE gn-convt THEN x-TotDias = gn-ConVt.TotDias.
      DETALLE:
      FOR EACH Ventas_Detalle OF Ventas_Cabecera NO-LOCK,
          FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia
          AND Almmmatg.codmat = Ventas_Detalle.codmat :
          /* Ventas SIN IGV solamente */
          IF Ventas_Detalle.ImpNacSIGV = ? THEN NEXT.
          IF Almmmatg.codfam = '009' THEN NEXT.
          /* Ventas con Margen de Utilidad solamente */
          ASSIGN
              x-MargenUtil = 0
              x-CtoLis = Almmmatg.CtoLis
              x-PreUni = Ventas_Detalle.ImpNacSIGV / Ventas_Detalle.Cantidad.
          IF Almmmatg.MonVta = 2 THEN x-CtoLis = Almmmatg.CtoLis * Almmmatg.TpoCmb.
          ASSIGN
              x-Utilidad = x-PreUni - x-CtoLis
              x-MargenUtil = x-Utilidad / x-CtoLis * 100.
          IF x-MargenUtil <= 0 THEN NEXT.
          /* INICIO */
          FIND FIRST T-DDOC WHERE T-DDOC.codcia = T-CDOC.codcia
              AND T-DDOC.coddoc = T-CDOC.coddoc
              AND T-DDOC.nrodoc = T-CDOC.nrodoc
              AND T-DDOC.codven = T-CDOC.codven
              AND T-DDOC.CodMat = Ventas_Detalle.codmat NO-ERROR.
          IF NOT AVAILABLE T-DDOC THEN CREATE T-DDOC.
          ASSIGN
              T-DDOC.codcia = s-codcia
              T-DDOC.coddoc = T-CDOC.coddoc
              T-DDOC.nrodoc = T-CDOC.nrodoc
              T-DDOC.coddiv = T-CDOC.coddiv
              T-DDOC.codven = T-CDOC.codven
              T-DDOC.codmat = Ventas_Detalle.codmat
              T-DDOC.candes = Ventas_Detalle.Cantidad
              T-DDOC.undvta = Almmmatg.undstk
              T-DDOC.implin = Ventas_Detalle.ImpNacSIGV
              T-DDOC.Flg_Factor = Almmmatg.TipArt
              T-DDOC.ImpComision = 0
              T-DDOC.ImpDcto_Adelanto[1] = x-CtoLis
              T-DDOC.ImpDcto_Adelanto[2] = x-Utilidad
              T-DDOC.ImpDcto_Adelanto[3] = x-MargenUtil
              T-DDOC.ImpDcto_Adelanto[5] = x-TotDias.
          ASSIGN
              x-PorComi = 0.
          /* 1ro Comisiones por Canal de Venta vs % Margen de Utilidad vs Linea vs Campaña */
          CASE Almmmatg.CodFam:
              WHEN "010" THEN DO:
                  FOR EACH TabGener NO-LOCK WHERE TabGener.codcia = s-codcia
                      AND TabGener.Clave = "%COMI-CV"
                      AND TabGener.Codigo =  GN-DIVI.CanalVenta + "|" + Almmmatg.CodFam
                      BY TabGener.ValorIni:
                      IF x-MargenUtil >= TabGener.ValorIni AND x-MargenUtil < TabGener.ValorFin THEN DO:
                          IF x-Campana = YES 
                              THEN x-PorComi = TabGener.Parametro[1].
                              ELSE x-PorComi = TabGener.Parametro[2].
                          ASSIGN
                              x-PorComi = TabGener.ValorIni * x-PorComi
                              T-DDOC.ImpComision = T-DDOC.implin * x-PorComi / 100
                              T-DDOC.ImpDcto_Adelanto[4] = TabGener.ValorIni.
                          LEAVE.
                      END.
                  END.
              END.
              OTHERWISE DO:
                  /*
                  IF estavtas.Ventas_Cabecera.CodDoc = 'BOL'
                      AND estavtas.Ventas_Cabecera.NroDoc = '006822153' THEN
                      MESSAGE 'inicio canal:' GN-DIVI.CanalVenta.
                      */
                  FOR EACH TabGener NO-LOCK WHERE TabGener.codcia = s-codcia
                      AND TabGener.Clave = "%COMI-CV"
                      AND TabGener.Codigo =  GN-DIVI.CanalVenta + "|" + "999"
                      BY TabGener.ValorIni:
                      IF x-MargenUtil >= TabGener.ValorIni AND x-MargenUtil < TabGener.ValorFin THEN DO:
                          IF x-Campana = YES 
                              THEN x-PorComi = TabGener.Parametro[1].
                              ELSE x-PorComi = TabGener.Parametro[2].
                          ASSIGN
                              x-PorComi = TabGener.ValorIni * x-PorComi
                              T-DDOC.ImpComision = T-DDOC.implin * x-PorComi / 100
                              T-DDOC.ImpDcto_Adelanto[4] = TabGener.ValorIni.
                          /*
                          IF estavtas.Ventas_Cabecera.CodDoc = 'BOL'
                              AND estavtas.Ventas_Cabecera.NroDoc = '006822153' THEN
                              MESSAGE 'detalle campaña?' x-campana 'margen' x-margenutil SKIP
                              'producto' estavtas.Ventas_Detalle.CodMat SKIP
                              '%comision:' x-porcomi tabgener.parametro[1] tabgener.parametro[2].
                              */
                          LEAVE.
                      END.
                  END.
              END.
          END CASE.
          ASSIGN
              T-DDOC.PorComision = x-PorComi.
          /* Castigo por Condicion de Venta */
          FOR EACH TabGener NO-LOCK WHERE TabGener.codcia = s-codcia
              AND TabGener.Clave = "%COMI-FP"
              BY TabGener.ValorIni:
              IF x-TotDias >= TabGener.ValorIni AND x-TotDias < TabGener.ValorFin THEN DO:
                  T-DDOC.ImpComision = T-DDOC.ImpComision * (1 - TabGener.Parametro[1] / 100).
                  ASSIGN
                      T-DDOC.PorCastigo = TabGener.Parametro[1].
                  LEAVE.
              END.
          END.
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
         HEIGHT             = 4
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


