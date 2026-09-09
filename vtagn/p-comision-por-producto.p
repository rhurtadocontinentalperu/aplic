&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Cálñculo de comisión

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER x-FchDoc AS DATE.
DEF INPUT PARAMETER x-CodDiv AS CHAR.   /* OJO: División ORIGEN */
DEF INPUT PARAMETER x-CodVen AS CHAR.
DEF INPUT PARAMETER x-FmaPgo AS CHAR.
DEF INPUT PARAMETER x-CodMat AS CHAR.
DEF INPUT PARAMETER x-CanDes AS DEC.    /* OJO: En unidades de stock */
DEF INPUT PARAMETER x-ImpLin AS DEC.    /* OJO: Sin IGV en SOLES */
DEF INPUT PARAMETER x-CodMon AS INT.    /* 1: Soles  2: Dólares */
DEF OUTPUT PARAMETER x-ImpComision AS DEC.

DEF VAR x-PorComi AS DEC NO-UNDO.
DEF VAR x-Metodo1 AS DEC NO-UNDO.
DEF VAR x-Metodo2 AS DEC NO-UNDO.
DEF VAR x-PorCastigo AS DEC NO-UNDO.

x-PorComi = 0.
x-ImpComision = 0.
x-Metodo1 = 0.
x-Metodo2 = 0.
x-PorCastigo  = 0.

DEF SHARED VAR s-codcia AS INT.

DEF VAR x-TpoCmbCmp AS DECI INIT 1 NO-UNDO.
DEF VAR x-TpoCmbVta AS DECI INIT 1 NO-UNDO.

ASSIGN
    x-TpoCmbVta = 1
    x-TpoCmbCmp = 1.

FIND LAST Gn-Tcmb WHERE Gn-Tcmb.Fecha <= x-FchDoc NO-LOCK NO-ERROR.
IF NOT AVAIL Gn-Tcmb THEN FIND FIRST Gn-Tcmb WHERE Gn-Tcmb.Fecha >= x-FchDoc NO-LOCK NO-ERROR.
IF AVAIL Gn-Tcmb THEN 
    ASSIGN
    x-TpoCmbCmp = Gn-Tcmb.Compra
    x-TpoCmbVta = Gn-Tcmb.Venta.
IF x-CodMon = 2 THEN x-ImpLin = x-ImpLin * x-TpoCmbVta.

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
         HEIGHT             = 3.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR x-Campana AS LOG NO-UNDO.
DEF VAR x-TotDias AS DEC NO-UNDO.
DEF VAR x-Utilidad AS DEC NO-UNDO.
DEF VAR x-MargenUtil AS DEC NO-UNDO.
DEF VAR x-CtoLis AS DEC NO-UNDO.
DEFINE VAR lCanalVtaDiv AS CHAR.
DEFINE VAR lCanalVta AS CHAR.
DEF VAR x-Codigo AS CHAR NO-UNDO.

ASSIGN
    x-Campana = NO
    x-TotDias = 0
    .
FIND LAST VtaTabla WHERE VtaTabla.codcia = s-codcia
    AND VtaTabla.Tabla = "CAMPAÑAS"
    AND x-FchDoc >= VtaTabla.Rango_Fecha[1]
    AND x-FchDoc <= VtaTabla.Rango_Fecha[2]
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN x-Campana = YES.
FIND gn-convt WHERE gn-ConVt.Codig =  x-FmaPgo NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt THEN x-TotDias = gn-ConVt.TotDias.

FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = x-CodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.
/* Ventas SIN IGV solamente */
IF Almmmatg.codfam = '009' THEN RETURN.
/* Ventas con Margen de Utilidad solamente */
ASSIGN
    x-MargenUtil = 0
    x-CtoLis = Almmmatg.CtoLis * x-CanDes.
IF Almmmatg.MonVta = 2 THEN x-CtoLis = x-CtoLis * Almmmatg.TpoCmb.
/* RHC 27/06/2017 Solicitado por Camus */
IF Almmmatg.CtoLis <= 0 THEN DO:
    FIND LAST AlmStkge WHERE AlmStkge.CodCia = Almmmatg.codcia
        AND AlmStkge.codmat = Almmmatg.codmat
        AND AlmStkge.Fecha <= TODAY
        NO-LOCK NO-ERROR.
    /* El costo promedio siempre está en SOLES y SIN IGV */
    IF AVAILABLE AlmStkge THEN x-CtoLis = AlmStkge.CtoUni * x-CanDes.
END.
/* *********************************** */
ASSIGN
    x-Utilidad   = x-ImpLin - x-CtoLis
    x-MargenUtil = x-Utilidad / x-CtoLis * 100.
IF x-MargenUtil <= 0 THEN RETURN.

ASSIGN
    x-PorComi = 0.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = x-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN RETURN.
/* 10 Nov2016 - Excepciones - Vendedores con otro CANALVENTA  */
DEFINE BUFFER b-tabgener FOR tabgener.
lCanalVtaDiv = GN-DIVI.CanalVenta.
lCanalVta    = GN-DIVI.CanalVenta.
/* RHC 11/05/2017 Solicitado por Cesar Camus */
IF GN-DIVI.CanalVenta <> "FER" THEN DO:
    FIND FIRST b-tabgener WHERE b-tabgener.codcia = s-codcia 
        AND b-tabgener.clave = 'VEND-EXC-COM' 
        AND b-tabgener.codigo = x-CodVen
        NO-LOCK NO-ERROR.
    IF AVAILABLE b-tabgener THEN lCanalVta = b-tabgener.libre_c01.
END.
/* 1ro Comisiones por Canal de Venta vs % Margen de Utilidad vs Linea vs Campaña */
CASE Almmmatg.CodFam:
    WHEN "010" THEN x-Codigo = lCanalVta + "|" + Almmmatg.CodFam.
    OTHERWISE x-Codigo = lCanalVta + "|" + "999".
END CASE.
FOR EACH TabGener NO-LOCK WHERE TabGener.codcia = s-codcia
    AND TabGener.Clave = "%COMI-CV"
    AND TabGener.Codigo =  x-Codigo
    BY TabGener.ValorIni:
    IF x-MargenUtil >= TabGener.ValorIni AND x-MargenUtil < TabGener.ValorFin THEN DO:
        IF x-Campana = YES THEN x-PorComi = TabGener.Parametro[1].
        ELSE x-PorComi = TabGener.Parametro[2].
        ASSIGN
            x-ImpComision = x-Utilidad * x-PorComi / 100
            x-Metodo1 = x-Utilidad * x-PorComi / 100
            x-Metodo2 = (x-Utilidad * TabGener.ValorIni / x-MargenUtil) * x-PorComi / 100
            .
        LEAVE.
    END.
END.
/* Castigo por Condicion de Venta */
FOR EACH TabGener NO-LOCK WHERE TabGener.codcia = s-codcia
    AND TabGener.Clave = "%COMI-FP"
    AND TabGener.Codigo = (IF Almmmatg.CodFam = "010" THEN Almmmatg.CodFam ELSE "999")
    BY TabGener.ValorIni:
    IF x-TotDias >= TabGener.ValorIni AND x-TotDias < TabGener.ValorFin THEN DO:
        x-ImpComision = x-ImpComision * (1 - TabGener.Parametro[1] / 100).
        x-PorCastigo = TabGener.Parametro[1].
        LEAVE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


