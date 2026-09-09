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

/* ************************************************************* */
/* RHC 14/10/2013 Descuentos por Volumen de Compra Acumulados    */
/* SOLO EXPOLIBRERIA (E)                                         */
/* ************************************************************* */

IF LOOKUP(s-TpoPed, "E") = 0 THEN RETURN.

/* ****************************************** */
/* RHC 06/09/2018 CONTROL POR LISTA DE PRECIO */
/* ****************************************** */
IF s-TpoPed = "E" THEN DO:
    FIND VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia AND
        VtaCTabla.Tabla = 'CFGLP' AND
        VtaCTabla.Llave = pCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE VtaCTabla AND VtaCTabla.Libre_l01 = NO THEN RETURN.
END.
/* ****************************************** */

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR X-TIPDTO AS CHAR INIT 'EDVXSALDOC' NO-UNDO.     /* Tipo de descuento aplicado */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.

/* BARREMOS TODAS LAS PROMOCIONES POR SALDOS */
DEF BUFFER B-FacTabla FOR FacTabla.
FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia AND 
    FacTabla.Tabla = "EDVXSALDOC"
    AND FacTabla.Codigo BEGINS pCodDiv
    AND TODAY >= FacTabla.Campo-D[1] 
    AND TODAY <= FacTabla.Campo-D[2] :
    /* POR CADA PROMOCION UN CALCULO NUEVO */
    EMPTY TEMP-TABLE ResumenxLinea.
    EMPTY TEMP-TABLE ErroresxLinea.
    /* *********************************** */
    FOR EACH B-FacTabla NO-LOCK WHERE B-FacTabla.codcia = s-codcia
        AND B-FacTabla.Tabla = "EDVXSALDOD"
        AND B-FacTabla.Codigo BEGINS FacTabla.Codigo,
        FIRST Facdpedi OF Faccpedi NO-LOCK WHERE Facdpedi.codmat = B-FacTabla.Campo-C[1],
        FIRST Almmmatg OF Facdpedi NO-LOCK:
        /* Transformamos la cantidad en unidad base a cantidad en unidad de dcto x volumen */
        FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
            AND Almtconv.Codalter = FacTabla.Campo-C[1]
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almtconv THEN DO:
            MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
                '        Unidad Base:' Almmmatg.UndBas SKIP
                'Unidad de Sub-Linea:' FacTabla.Campo-C[1] SKIP(1)
                'SE CONTINUARÁ CON OTRO ARTÍCULO' SKIP(2)
                '*** Avisar a Sistemas ***'
                VIEW-AS ALERT-BOX WARNING TITLE "DESCUENTO POR VOLUMEN POR SALDOS".
            FIND FIRST ErroresxLinea WHERE ErroresxLinea.codmat = Almmmatg.codmat NO-ERROR.
            IF NOT AVAILABLE ErroresxLinea THEN CREATE ErroresxLinea.
            ASSIGN
                ErroresxLinea.codmat = Almmmatg.codmat.
            NEXT.
        END.
        ASSIGN
            F-FACTOR = Almtconv.Equival.
        /* ******************************************************************************* */
        FIND FIRST ResumenxLinea WHERE ResumenxLinea.codmat = Almmmatg.codmat NO-ERROR.
        IF NOT AVAILABLE ResumenxLinea THEN CREATE ResumenxLinea.
        ASSIGN
            ResumenxLinea.codmat = Almmmatg.codmat
            ResumenxLinea.canped = ResumenxLinea.canped + (facdpedi.canped * facdpedi.factor / f-Factor).
    END.
    X-CANTI = 0.
    FOR EACH ResumenxLinea:
        X-CANTI = X-CANTI + ResumenxLinea.canped.
    END.
    /* AHORA SÍ APLICAMOS DESCUENTOS */
    ASSIGN
        x-DctoxVolumen = 0
        x-Rango = 0.
    DO J = 1 TO 10:
        IF X-CANTI >= FacTabla.Valor[j] AND FacTabla.Valor[j + 10] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = FacTabla.Valor[j].
            IF X-RANGO <= FacTabla.Valor[j] THEN DO:
                ASSIGN
                    X-RANGO  = FacTabla.Valor[j]
                    x-DctoxVolumen = FacTabla.Valor[j + 10].
            END.   
        END.   
    END.
    /* ************************************************************ */
    /* RHC 28/10/2013 SE VA A RECALCULAR EL PRECIO DE LA COTIZACION */
    /* RHC 27/12/2018 SE VA A TOMAR EL PRECIO BASE                  */
    /* ************************************************************ */
    IF x-DctoxVolumen > 0 THEN DO:
        FOR EACH ResumenxLinea,
            FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ResumenxLinea.codmat,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
            ASSIGN 
                Facdpedi.PreUni        = Facdpedi.PreBas    /* Se cambia al precio de oficina (lista) */
                Facdpedi.Por_Dsctos[1] = 0                  /* Todos los demás descuentos */
                Facdpedi.Por_Dsctos[2] = 0                  /* NO se toman en cuenta */
                Facdpedi.Por_Dsctos[3] = x-DctoxVolumen     /* Dcto VOL o PROM */
                Facdpedi.Libre_c04 = x-TipDto.
            ASSIGN
                Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                            ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
            IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
                THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
            /* RHC 04/08/2015 Si existe f-FleteUnitario se recalcula el Descuento */
            IF Facdpedi.Libre_d02 > 0 THEN DO:      /* FLETE UNITARIO NO VARIA */
                /* El flete afecta el monto final */
                IF Facdpedi.ImpDto = 0 THEN DO:       /* NO tiene ningun descuento */
                    ASSIGN
                        Facdpedi.PreUni = ROUND(Facdpedi.PreUni + Facdpedi.Libre_d02, s-NroDec)  /* Incrementamos el PreUni */
                        Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni.
                END.
                ELSE DO:      /* CON descuento promocional o volumen */
                    ASSIGN
                        Facdpedi.ImpLin = Facdpedi.ImpLin + (Facdpedi.CanPed * Facdpedi.Libre_d02)
                        Facdpedi.PreUni = ROUND( (Facdpedi.ImpLin + Facdpedi.ImpDto) / Facdpedi.CanPed, s-NroDec).
                END.
            END.
            /* ***************************************************************** */
            ASSIGN
                Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
                Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
            IF Facdpedi.AftIsc THEN 
                Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE Facdpedi.ImpIsc = 0.
                 IF Facdpedi.AftIgv THEN  
                     Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (s-PorIgv / 100)),4).
                 ELSE Facdpedi.ImpIgv = 0.
        END.
    END.
END.

/*
    IF x-DctoxVolumen > 0 THEN DO:
        FOR EACH ResumenxLinea,
            FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ResumenxLinea.codmat,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
            ASSIGN 
                Facdpedi.Por_Dsctos[3] = x-DctoxVolumen     /* Dcto VOL o PROM */
                Facdpedi.Libre_c04 = x-TipDto.
            ASSIGN
                Facdpedi.ImpLin = ROUND ( Facdpedi.CanPed * Facdpedi.PreUni * 
                            ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                            ( 1 - Facdpedi.Por_Dsctos[3] / 100 ), 2 ).
            IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
                THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
            ASSIGN
                Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
                Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
            IF Facdpedi.AftIsc THEN 
                Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
            ELSE Facdpedi.ImpIsc = 0.
            IF Facdpedi.AftIgv THEN  
                Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (s-PorIgv / 100)),4).
            ELSE Facdpedi.ImpIgv = 0.
        END.
    END.
*/

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
         HEIGHT             = 4.42
         WIDTH              = 59.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


