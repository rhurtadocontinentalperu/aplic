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
                IF x-CanMin > 0 AND x-CanMin <= x-CanDes THEN x-Factor = TRUNCATE(x-CanDes / x-CanMin, 0).
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


