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
/* SOLO VENTA NORMAL LIMA (N), EXPOLIBRERIA (E) y PROVINCIAS (P) */
/* ************************************************************* */

IF LOOKUP(s-TpoPed, "N") = 0 THEN RETURN.

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR F-PREBAS AS DEC  DECIMALS 4 NO-UNDO.
DEF VAR F-PREVTA AS DEC  DECIMALS 4 NO-UNDO.
DEF VAR Y-DSCTOS AS DEC  NO-UNDO.                /* Descuento por Volumen y/o Promocional */
DEF VAR X-TIPDTO AS CHAR NO-UNDO.               /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.
DEF VAR F-DSCTOS AS DEC  NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEF VAR x-CndVta  AS CHAR NO-UNDO.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
/* ****************************************** */
/* FORZAMOS CIERTOS VALORES */
ASSIGN
    x-ClfCli = "C"              /* FORZAMOS A "C" */
    x-ClfCli2 = "C"
    x-CndVta = "000".           /* FORZAMOS LA CONDICION DE VENTA */

/* BARREMOS TODAS LAS PROMOCIONES POR SALDOS */
DEF BUFFER B-FacTabla FOR FacTabla.
FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia AND FacTabla.Tabla = "DVXSALDOC"
    AND TODAY >= FacTabla.Campo-D[1] 
    AND TODAY <= FacTabla.Campo-D[2] :
    /* POR CADA PROMOCION UN CALCULO NUEVO */
    EMPTY TEMP-TABLE ResumenxLinea.
    EMPTY TEMP-TABLE ErroresxLinea.
    /* *********************************** */
    FOR EACH B-FacTabla NO-LOCK WHERE B-FacTabla.codcia = s-codcia
        AND B-FacTabla.Tabla = "DVXSALDOD"
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
    /* ************************************************************ */
    IF x-DctoxVolumen > 0 THEN DO:
        FOR EACH ResumenxLinea,
            FIRST Facdpedi OF Faccpedi WHERE Facdpedi.codmat = ResumenxLinea.codmat,
            FIRST Almmmatg OF Facdpedi NO-LOCK:
            FIND FIRST VtaListaMay WHERE VtaListaMay.codcia = Facdpedi.codcia
                AND VtaListaMay.coddiv = pCodDiv
                AND VtaListaMay.codmat = Facdpedi.codmat
                NO-LOCK NO-ERROR.
            /* Determinamos el precio base */
            ASSIGN
                F-DSCTOS = 0
                F-PreBas = Almmmatg.PreOfi.
            IF gn-divi.VentaMayorista = 2 AND AVAILABLE VtaListaMay THEN F-PreBas = VtaListaMay.PreOfi.
            /* ************************************************************* */
            /* DESCUENTOS POR CLASIFICACION DE CLIENTES Y CONDICION DE VENTA */
            /* ************************************************************* */
            /* AHORA DEPENDE SI EL PRODUCTO ES PROPIO O DE TERCEROS */
            /* DESCUENTO POR CLASIFICACION DEL PRODUCTO */
            ASSIGN
                MaxCat = 0                      /* Descuento por Clasificación del Cliente */
                MaxVta = 0.                     /* Descuento por Condición de Venta */
            IF Almmmatg.chr__02 = "P" THEN DO:  /* PROPIOS */
                FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
                IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc.
            END.
            ELSE DO:        /* TERCEROS */
                FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI2 NO-LOCK NO-ERROR.
                IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc1.
            END.
            /* *************************************************** */
            /* DESCUENTO POR CONDICION DE VENTA Y TIPO DE PRODUCTO */
            /* *************************************************** */
            FIND Dsctos WHERE Dsctos.CndVta = X-CNDVTA
                AND Dsctos.clfCli = Almmmatg.Chr__02
                NO-LOCK NO-ERROR.
            IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
            ASSIGN
                F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100
                Y-DSCTOS = x-DctoxVolumen          /* OJO */
                X-TIPDTO = "DVXSALDO".
            /* ******************************** */
            /* PRECIO BASE A LA MONEDA DE VENTA */
            /* ******************************** */
            IF S-CODMON = 1 THEN DO:
                IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = F-PREBAS * Almmmatg.TpoCmb.
            END.
            IF S-CODMON = 2 THEN DO:
                IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
                ELSE ASSIGN F-PREBAS = (F-PREBAS / Almmmatg.TpoCmb).
            END.
            F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
            /************************************************/
            RUN BIN/_ROUND1(F-PREVTA,s-NRODEC,OUTPUT F-PREVTA).
            /************************************************/
            ASSIGN 
                Facdpedi.PreBas  = f-PreBas
                Facdpedi.PreUni  = f-PreVta
                Facdpedi.PorDto  = 0
                Facdpedi.PorDto2 = 0            /* el precio unitario */
                Facdpedi.Por_Dsctos[2] = 0
                Facdpedi.Por_Dsctos[3] = Y-DSCTOS 
                Facdpedi.ImpIsc = 0
                Facdpedi.ImpIgv = 0
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
         HEIGHT             = 3.67
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


