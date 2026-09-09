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
         HEIGHT             = 5.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* PROMOCIONES PARA PEDIDOS CREDITO*/

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pError AS LOG.  /* YES considera error NO no considera el error */

DEF VAR p-CodAlm AS CHAR.
DEF VAR s-UndVta AS CHAR.
DEF VAR f-Factor AS DEC.

FIND FacCPedi WHERE ROWID(FacCPedi) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCPedi THEN RETURN.
IF LOOKUP (FacCPedi.FmaPgo, '900,999') > 0 THEN RETURN.
p-CodAlm = ENTRY(1, FacCPedi.CodAlm).   /* EL ALMACÉN POR DEFECTO */

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
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE SW-LOG1  AS LOGI NO-UNDO.
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.
DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

/* Barremos las promociones activas */
RUN Promociones-Configuradas.
RUN Promociones-Manuales.

/* Cargamos las promociones al pedido */
/* RHC 20.10.2011 Chequeamos si se pude descargar y si hay stock */
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
    /* chequeamos stock disponible en el almacén de despacho */
    s-Ok = NO.
    ASSIGN
        Promocion.AlmDes = p-CodAlm
        x-StkAct = 0.
    FIND Almmmate WHERE Almmmate.codcia = FacCPedi.CodCia
        AND Almmmate.codalm = Promocion.AlmDes
        AND Almmmate.codmat = Promocion.CodMat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmate THEN DO:
        MESSAGE 'Producto promocional' Promocion.CodMat Almmmatg.desmat SKIP
            'NO asignado al almacén' Promocion.Almdes SKIP
            VIEW-AS ALERT-BOX WARNING.
        NEXT.
    END.
    IF AVAILABLE Almmmate THEN x-StkAct = Almmmate.StkAct.
    RUN vta2/Stock-Comprometido (Promocion.CodMat, Promocion.AlmDes, OUTPUT s-StkComprometido).
    s-StkDis = x-StkAct - s-StkComprometido.
    IF s-StkDis >= Promocion.CanPed * Promocion.factor THEN s-Ok = YES.
    IF pError = NO THEN s-Ok = YES.     /* OJO */
    IF s-Ok = NO THEN DO:
        MESSAGE 'NO hay stock disponible para la promoción:' SKIP
            Promocion.codmat Almmmatg.desmat SKIP
            'Promoción:' Promocion.CanPed * Promocion.factor Promocion.UndVta SKIP(1)
            'Stock Disponible para el Almacén' Promocion.AlmDes ':' s-StkDis SKIP
            'Stock Actual:' x-StkAct SKIP
            'Stock Comprometido:' s-StkComprometido 
            VIEW-AS ALERT-BOX WARNING.
        NEXT.
    END.
    /* RHC 13/08/2012 NO SE PUEDE REPETIR EL CODIGO */
    FIND FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = Promocion.CodMat
        NO-LOCK NO-ERROR.
    IF AVAILABLE Facdpedi THEN NEXT.
    /* ******************************************** */
    I-NITEM = I-NITEM + 1.
    CREATE FacDPedi.
    BUFFER-COPY Promocion 
        TO FacDPedi
        ASSIGN
        FacDPedi.CodCia = FacCPedi.CodCia
        FacDPedi.CodDiv = FacCPedi.CodDiv
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


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Promociones-Configuradas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Promociones-Configuradas Procedure 
PROCEDURE Promociones-Configuradas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
        IF x-Factor <= 0 OR x-Factor = ? THEN LEAVE PROMOCIONES.
        /* cargamos las promociones */
        CASE Vtacprom.TipProm:
            WHEN 1 OR WHEN 2 THEN DO:
                FOR EACH Vtadprom OF Vtacprom NO-LOCK WHERE Vtadprom.Tipo = 'G', FIRST Almmmatg OF Vtadprom NO-LOCK:
                    FIND Promocion WHERE Promocion.codmat = Vtadprom.codmat NO-ERROR.
                    IF NOT AVAILABLE Promocion THEN CREATE Promocion.
                    ASSIGN
                        Promocion.codcia = FacCPedi.codcia
                        Promocion.coddiv = FacCPedi.coddiv
                        Promocion.almdes = ENTRY(1, FacCPedi.codalm)    /* Almacén por defecto */
                        Promocion.codmat = Vtadprom.codmat
                        Promocion.canped = Promocion.canped + ( Vtadprom.cantidad * x-Factor )
                        Promocion.undvta = Almmmatg.undbas
                        Promocion.aftigv = Almmmatg.AftIgv
                        Promocion.factor = 1.
                    IF Vtadprom.Tope > 0 AND Promocion.canped > Vtadprom.Tope THEN Promocion.canped = Vtadprom.Tope.
                    RUN vta2/PrecioMayorista-Cred (
                        FacCPedi.TpoPed,
                        FacCPedi.CodDiv,
                        FacCPedi.CodCli,
                        FacCPedi.CodMon,
                        INPUT-OUTPUT s-UndVta,
                        OUTPUT f-Factor,
                        Almmmatg.CodMat,
                        FacCPedi.FmaPgo,
                        Promocion.CanPed,
                        FacCPedi.Libre_d01,
                        OUTPUT f-PreBas,
                        OUTPUT f-PreVta,
                        OUTPUT f-Dsctos,
                        OUTPUT y-Dsctos,
                        OUTPUT z-Dsctos,
                        OUTPUT x-TipDto,
                        FALSE
                        ).
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
                        RUN vta2/PrecioMayorista-Cred (
                            FacCPedi.TpoPed,
                            FacCPedi.CodDiv,
                            FacCPedi.CodCli,
                            FacCPedi.CodMon,
                            INPUT-OUTPUT s-UndVta,
                            OUTPUT f-Factor,
                            Almmmatg.CodMat,
                            FacCPedi.FmaPgo,
                            Promocion.CanPed,
                            FacCPedi.Libre_d01,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos,
                            OUTPUT z-Dsctos,
                            OUTPUT x-TipDto,
                            FALSE
                            ).
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Promociones-Manuales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Promociones-Manuales Procedure 
PROCEDURE Promociones-Manuales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF TODAY >= 08/01/2012 AND TODAY <= 08/31/2012 THEN DO:
    /* ACUMULAMOS POR PRODUCTOS STANDFORD */
    DEF VAR x-010 AS DEC NO-UNDO.
    DEF VAR x-012 AS DEC NO-UNDO.

    ASSIGN
        x-010 = 0
        x-012 = 0.
    FOR EACH facdpedi OF faccpedi WHERE facdpedi.libre_c05 <> 'OF',
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        CASE Almmmatg.codfam:
            WHEN "010" THEN x-010 = x-010 + facdpedi.implin.
            WHEN "012" THEN x-012 = x-012 + facdpedi.implin.
        END CASE.
    END.
    /* PACK 4 */
    IF x-012 >= 200 AND x-012 + x-010 >= 1500 THEN DO:
        RUN Registro-Promocion-Manual ('039472').
        RETURN.
    END.
    /* PACK 3 */
    IF x-012 >= 100 AND x-012 + x-010 >= 1000 THEN DO:
        RUN Registro-Promocion-Manual ('039471').
        RETURN.
    END.
    /* PACK 2 */
    IF x-012 >= 100 AND x-012 + x-010 >= 500 THEN DO:
        RUN Registro-Promocion-Manual ('039470').
        RETURN.
    END.
    /* PACK 1 */
    IF x-012 >= 100 AND x-012 + x-010 >= 200 THEN DO:
        RUN Registro-Promocion-Manual ('026223').
        RETURN.
    END.
END.

IF TODAY <= 03/20/2014 THEN DO:
    DEF VAR x-Artesco AS DEC NO-UNDO.

    FOR EACH facdpedi OF faccpedi WHERE facdpedi.libre_c05 <> 'OF',
        FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.Codpr1 = "10006732":
        x-Artesco = x-Artesco + Facdpedi.ImpLin.
    END.
    IF x-Artesco >= 30 THEN DO:
        RUN Registro-Promocion-Manual ('066366').
    END.
    IF x-Artesco >= 50 THEN DO:
        RUN Registro-Promocion-Manual ('066393').
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Registro-Promocion-Manual) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registro-Promocion-Manual Procedure 
PROCEDURE Registro-Promocion-Manual :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pCodMat AS CHAR.

FIND Almmmatg WHERE Almmmatg.codcia = Faccpedi.codcia
    AND Almmmatg.codmat = pCodMat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Promoción:' pCodMat 'NO registrada en el catálogo de productos'
        VIEW-AS ALERT-BOX WARNING.
    RETURN.
END.
CREATE Promocion.
ASSIGN
    Promocion.codcia = FacCPedi.codcia
    Promocion.coddiv = FacCPedi.coddiv
    Promocion.almdes = ENTRY(1, FacCPedi.codalm)    /* Almacén por defecto */
    Promocion.codmat = pCodMat
    Promocion.canped = 1
    Promocion.undvta = Almmmatg.undbas
    Promocion.aftigv = Almmmatg.AftIgv
    Promocion.factor = 1.
RUN vta2/PrecioMayorista-Cred (
    FacCPedi.TpoPed,
    FacCPedi.CodDiv,
    FacCPedi.CodCli,
    FacCPedi.CodMon,
    INPUT-OUTPUT s-UndVta,
    OUTPUT f-Factor,
    Almmmatg.CodMat,
    FacCPedi.FmaPgo,
    Promocion.CanPed,
    FacCPedi.Libre_d01,
    OUTPUT f-PreBas,
    OUTPUT f-PreVta,
    OUTPUT f-Dsctos,
    OUTPUT y-Dsctos,
    OUTPUT z-Dsctos,
    OUTPUT x-TipDto,
    FALSE
    ).
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

