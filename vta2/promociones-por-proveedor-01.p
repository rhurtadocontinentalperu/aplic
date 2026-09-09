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
         HEIGHT             = 4.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* PROMOCIONES PARA PEDIDOS CREDITO*/

DEF INPUT PARAMETER pRowid AS ROWID.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF VAR p-CodAlm AS CHAR.

FIND FacCPedi WHERE ROWID(FacCPedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.
IF LOOKUP (FacCPedi.FmaPgo, '900,999') > 0 THEN RETURN.

/* cargamos los almacenes de despacho */
p-CodAlm = s-CodAlm.
FOR EACH VtaAlmDiv NO-LOCK WHERE VtaAlmDiv.codcia = s-codcia
    AND VtaAlmDiv.coddiv = Faccpedi.coddiv
    BY VtaAlmDiv.Orden:
    p-CodAlm = TRIM (p-CodAlm) + ',' + TRIM(VtaAlmDiv.CodAlm).
END.

/* NO Contrato Marco NI Supermercados */
DEF BUFFER B-CPEDI FOR Faccpedi.
FIND B-CPEDI WHERE B-CPEDI.codcia = Faccpedi.codcia
    AND B-CPEDI.coddoc = Faccpedi.codref
    AND B-CPEDI.nroped = Faccpedi.nroref
    NO-LOCK NO-ERROR.
IF AVAILABLE(B-CPEDI) AND B-CPEDI.TpoPed = 'M' THEN RETURN.     /* Contrato Marco */
IF AVAILABLE(B-CPEDI) AND B-CPEDI.TpoPed = 'S' THEN RETURN.     /* Supermercados */
/* ********************************** */

DEF TEMP-TABLE Detalle
    FIELD codmat LIKE FacDPedi.codmat
    FIELD canped LIKE FacDPedi.canped
    FIELD implin LIKE FacDPedi.implin
    FIELD impmin AS DEC         /* Importes y cantidades minimas */
    FIELD canmin AS DEC.

DEF TEMP-TABLE Promocion LIKE FacDPedi.

DEF VAR x-ImpLin AS DEC.
DEF VAR x-CanDes AS DEC.
DEF VAR x-ImpMin AS DEC.
DEF VAR x-CanMin AS DEC.
DEF VAR x-Factor AS INT.
DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.
DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

/* Barremos las promociones activas */
FOR EACH Vtacprom NO-LOCK WHERE Vtacprom.codcia = FacCPedi.codcia
    AND Vtacprom.coddiv = FacCPedi.coddiv
    AND Vtacprom.coddoc = 'PRO'
    AND Vtacprom.FlgEst = 'A'
    AND (TODAY >= VtaCProm.Desde AND TODAY <= VtaCProm.Hasta):
    /* Acumulamos los productos promocionables */
    EMPTY TEMP-TABLE Detalle.   /* Limpiamos temporal */
    FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'P':
        FIND FacDPedi OF FacCPedi WHERE FacDPedi.codmat = Vtadprom.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE FacDPedi THEN DO:
            FIND Detalle WHERE Detalle.codmat = FacDPedi.codmat NO-ERROR.
            IF NOT AVAILABLE Detalle THEN CREATE Detalle.
            ASSIGN
                Detalle.codmat = Vtadprom.codmat
                Detalle.canped = Detalle.canped + ( FacDPedi.canped * FacDPedi.Factor )
                Detalle.implin = Detalle.implin + FacDPedi.implin
                Detalle.impmin = Vtadprom.importe
                Detalle.canmin = Vtadprom.cantidad.
        END.
    END.
    /* Generamos la promocion */
    PROMOCIONES:
    DO:
        x-Factor = 0.
        CASE Vtacprom.TipProm:
            WHEN 1 THEN DO:     /* Por Importes */
                x-ImpLin = 0.
                FOR EACH Detalle:
                    IF FacCPedi.CodMon = Vtacprom.codmon THEN x-ImpMin = Detalle.ImpMin.
                    ELSE IF FacCPedi.CodMon = 1 THEN x-ImpMin = Detalle.ImpMin * FacCPedi.TpoCmb.
                                                ELSE x-ImpMin = Detalle.ImpMin / FacCPedi.TpoCmb.
                    IF x-ImpMin > 0 AND x-ImpMin > Detalle.ImpLin THEN NEXT.
                    x-ImpLin = x-ImpLin + Detalle.ImpLin.
                END.
                x-ImpMin = Vtacprom.Importe.
                IF FacCPedi.CodMon <> Vtacprom.CodMon
                    THEN IF FacCPedi.CodMon = 1 THEN x-ImpLin = x-ImpLin / FacCPedi.TpoCmb.
                                                ELSE x-ImpLin = x-ImpLin * FacCPedi.TpoCmb.
                IF x-ImpMin <= x-ImpLin THEN x-Factor = TRUNCATE(x-ImpLin / x-ImpMin, 0).
            END.
            WHEN 2 THEN DO:     /* Por cantidades */
                x-CanDes = 0.
                FOR EACH Detalle:
                    IF Detalle.CanMin > 0 AND Detalle.CanMin > Detalle.CanPed THEN NEXT.
                    x-CanDes = x-CanDes + Detalle.CanPed.
                END.
                x-CanMin = Vtacprom.Cantidad.
                IF x-CanMin <= x-CanDes THEN x-Factor = TRUNCATE(x-CanDes / x-CanMin, 0).
            END.
            WHEN 3 THEN DO:     /* Por importes y proveedor  */
                x-ImpLin = 0.
                FOR EACH FacDPedi OF FacCPedi NO-LOCK, FIRST Almmmatg OF Facdpedi WHERE Almmmatg.codpr1 = VtaCProm.CodPro:
                    x-ImpLin = x-ImpLin + FacDPedi.ImpLin.
                END.
                IF FacCPedi.CodMon = 2 THEN x-ImpLin = x-ImpLin * FacCPedi.TpoCmb.
                x-Factor = 1.
            END.
        END CASE.
        IF x-Factor <= 0 THEN LEAVE PROMOCIONES.
        /* cargamos las promociones */
        CASE Vtacprom.TipProm:
            WHEN 1 OR WHEN 2 THEN DO:
                FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'G', FIRST Almmmatg OF Vtadprom NO-LOCK:
                    FIND Promocion WHERE Promocion.codmat = Vtadprom.codmat NO-ERROR.
                    IF NOT AVAILABLE Promocion THEN CREATE Promocion.
                    ASSIGN
                        Promocion.codcia = FacCPedi.codcia
                        Promocion.coddiv = FacCPedi.coddiv
                        Promocion.almdes = FacCPedi.codalm
                        Promocion.codmat = Vtadprom.codmat
                        Promocion.canped = Promocion.canped + ( Vtadprom.cantidad * x-Factor )
                        Promocion.undvta = Almmmatg.undbas
                        Promocion.aftigv = Almmmatg.AftIgv
                        Promocion.factor = 1.
                    IF Vtadprom.Tope > 0 AND Promocion.canped > Vtadprom.Tope
                        THEN Promocion.canped = Vtadprom.Tope.
                    RUN vtamay/PrecioVenta-3 (Faccpedi.CodCia,
                                        Faccpedi.CodDiv,
                                        Faccpedi.CodCli,
                                        Faccpedi.CodMon,
                                        Faccpedi.TpoCmb,
                                        1,
                                        Almmmatg.CodMat,
                                        Faccpedi.FmaPgo,
                                        Promocion.CanPed,
                                        4,
                                        Faccpedi.codalm,
                                        OUTPUT f-PreBas,
                                        OUTPUT f-PreVta,
                                        OUTPUT f-Dsctos,
                                        OUTPUT y-Dsctos,
                                        OUTPUT x-TipDto).
                    ASSIGN
                        Promocion.PorDto = f-Dsctos
                        Promocion.PreBas = f-PreBas
                        Promocion.PreUni = f-PreVta
                        Promocion.Libre_c04 = x-TipDto
                        Promocion.Libre_c05 = 'OF'          /* Marca de PROMOCION */
                        Promocion.Por_Dsctos[3] = 100      /* AL 100 % */
                        Promocion.ImpLin = 0
                        Promocion.ImpDto = Promocion.CanPed * Promocion.PreUni - Promocion.ImpLin.
                    /* Ajuste por IGV */
                    /*IF Promocion.AftIgv = YES THEN Promocion.ImpDto = Promocion.ImpDto / ( 1 + FacCPedi.PorIgv / 100).*/
                    ASSIGN
                        Promocion.ImpLin = ROUND(Promocion.ImpLin, 2)
                        Promocion.ImpDto = ROUND(Promocion.ImpDto, 2).
                END.
            END.
            WHEN 3 THEN DO:
                FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'G', FIRST Almmmatg OF Vtadprom NO-LOCK
                    BY Vtadprom.Importe DESC:
                    IF x-ImpLin >= Vtadprom.Importe THEN DO:
                        FIND Promocion WHERE Promocion.codmat = Vtadprom.codmat NO-ERROR.
                        IF NOT AVAILABLE Promocion THEN CREATE Promocion.
                        ASSIGN
                            Promocion.codcia = FacCPedi.codcia
                            Promocion.coddiv = FacCPedi.coddiv
                            Promocion.almdes = FacCPedi.codalm
                            Promocion.codmat = Vtadprom.codmat
                            Promocion.canped = Promocion.canped + ( Vtadprom.cantidad * x-Factor )
                            Promocion.undvta = Almmmatg.undbas
                            Promocion.aftigv = Almmmatg.AftIgv
                            Promocion.factor = 1.
                        IF Vtadprom.Tope > 0 AND Promocion.canped > Vtadprom.Tope
                            THEN Promocion.canped = Vtadprom.Tope.
                        RUN vtamay/PrecioVenta-3 (Faccpedi.CodCia,
                                            Faccpedi.CodDiv,
                                            Faccpedi.CodCli,
                                            Faccpedi.CodMon,
                                            Faccpedi.TpoCmb,
                                            1,
                                            Almmmatg.CodMat,
                                            Faccpedi.FmaPgo,
                                            Promocion.CanPed,
                                            4,
                                            Faccpedi.codalm,
                                            OUTPUT f-PreBas,
                                            OUTPUT f-PreVta,
                                            OUTPUT f-Dsctos,
                                            OUTPUT y-Dsctos,
                                            OUTPUT x-TipDto).
                        ASSIGN
                            Promocion.PorDto = f-Dsctos
                            Promocion.PreBas = f-PreBas
                            Promocion.PreUni = f-PreVta
                            Promocion.Libre_c04 = x-TipDto
                            Promocion.Libre_c05 = 'OF'          /* Marca de PROMOCION */
                            Promocion.Por_Dsctos[3] = 100      /* AL 100 % */
                            Promocion.ImpLin = 0
                            Promocion.ImpDto = Promocion.CanPed * Promocion.PreUni - Promocion.ImpLin.
                        /* Ajuste por IGV */
                        /*IF Promocion.AftIgv = YES THEN Promocion.ImpDto = Promocion.ImpDto / ( 1 + FacCPedi.PorIgv / 100).*/
                        ASSIGN
                            Promocion.ImpLin = ROUND(Promocion.ImpLin, 2)
                            Promocion.ImpDto = ROUND(Promocion.ImpDto, 2).

                        LEAVE PROMOCIONES.    /* <<< OJO <<< */
                    END.
                END.
            END.
        END CASE.
    END.
END.

/* Cargamos las promociones al pedido */
/* RHC 20.10.2011 Chequeamos de cual almacén se pude descargar y si hay stock */
DEF VAR k AS INT.
DEF VAR s-StkComprometido AS DEC.
DEF VAR x-StkAct AS DEC.
DEF VAR s-StkDis AS DEC.
DEF VAR s-Ok AS LOG.

i-nItem = 0.
FOR EACH FacDPedi OF FacCPedi NO-LOCK:
    i-nItem = i-nItem + 1.
END.

FOR EACH Promocion, FIRST Almmmatg OF Promocion NO-LOCK
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN "ADM-ERROR":
    /* chequeamos stock disponible de los almacenes de despacho */
    s-Ok = NO.
    PORALMACEN:
    DO k = 1 TO NUM-ENTRIES(p-CodAlm):
        ASSIGN
            Promocion.AlmDes = ENTRY(k, p-CodAlm)
            x-StkAct = 0.
        FIND Almmmate WHERE Almmmate.codcia = s-codcia
            AND Almmmate.codalm = Promocion.AlmDes
            AND Almmmate.codmat = Promocion.CodMat
            NO-LOCK NO-ERROR .
        IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
        RUN vtagn/Stock-Comprometido (Promocion.CodMat, Promocion.AlmDes, OUTPUT s-StkComprometido).
        s-StkDis = x-StkAct - s-StkComprometido.
        IF s-StkDis >= Promocion.CanPed * Promocion.factor THEN DO:
            s-Ok = YES.
            LEAVE PORALMACEN.
        END.
    END.
    IF s-Ok = NO THEN DO:
        MESSAGE 'NO hay stock disponible para la promoción' Promocion.codmat SKIP
            'Generación abortada'
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    I-NITEM = I-NITEM + 1.
    
    CREATE FacDPedi.
    BUFFER-COPY Promocion 
        TO FacDPedi
        ASSIGN
        FacDPedi.CodCia = FacCPedi.CodCia
        FacDPedi.coddoc = FacCPedi.coddoc
        FacDPedi.NroPed = FacCPedi.NroPed
        FacDPedi.FchPed = FacCPedi.FchPed
        FacDPedi.Hora   = FacCPedi.Hora 
        FacDPedi.FlgEst = FacCPedi.FlgEst
        FacDPedi.NroItm = I-NITEM
        FacDPedi.CanPick = FacDPedi.CanPed      /* OJO */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        MESSAGE 'No se pudo grabar la promoción:' Promocion.codmat
            VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    RELEASE FacDPedi.
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


