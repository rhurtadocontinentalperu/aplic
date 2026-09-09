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
/* (I) INSTITUCIONALES (P) PROVINCIAS                            */
/* ************************************************************* */
IF LOOKUP(s-TpoPed, "N,E,P,I") = 0 THEN RETURN.
/* ************************************************************* */

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.
DEF VAR x-DctoxVolumen AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR F-PREBAS AS DEC DECIMALS 4 NO-UNDO.
DEF VAR F-PREVTA AS DEC DECIMALS 4 NO-UNDO.
DEF VAR Y-DSCTOS AS DEC NO-UNDO.                /* Descuento por Volumen y/o Promocional */
DEF VAR X-TIPDTO AS CHAR NO-UNDO.               /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR F-FACTOR AS DECI NO-UNDO.

/* Variables para definir la lista de precios */
/* CONTROL POR DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-FlgDtoClfCli LIKE GN-DIVI.FlgDtoClfCli NO-UNDO.
DEF VAR x-FlgDtoCndVta LIKE GN-DIVI.FlgDtoCndVta NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Exluyenbres, acumulados o el mejor */

/* ****************************************** */
/* CONFIGURACIONES DE LA DIVISION */
/* ****************************************** */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pCodDiv NO-LOCK.
ASSIGN
    x-FlgDtoVol = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-FlgDtoClfCli = GN-DIVI.FlgDtoClfCli       /* Descuento por Clasificacion */
    x-FlgDtoCndVta = GN-DIVI.FlgDtoCndVta       /* Descuento por venta */
    x-Libre_C01 = GN-DIVI.Libre_C01.            /* Tipo de descuento */
/* ****************************************** */
/* RHC 06/09/2018 CONTROL POR LISTA DE PRECIO */
/* ****************************************** */
IF s-TpoPed = "E" THEN DO:
    FIND VtaCTabla WHERE VtaCTabla.CodCia = s-CodCia AND
        VtaCTabla.Tabla = 'CFGLP' AND
        VtaCTabla.Llave = pCodDiv NO-LOCK NO-ERROR.
    IF AVAILABLE VtaCTabla THEN x-FlgDtoVol = VtaCTabla.Libre_l01.
END.
/* ****************************************** */

IF x-FlgDtoVol = NO THEN RETURN.    /* <<< OJO: La Lista debe estar configurada <<< */

EMPTY TEMP-TABLE ResumenxLinea.
EMPTY TEMP-TABLE ErroresxLinea.

FOR EACH facdpedi OF Faccpedi NO-LOCK,
    FIRST Almmmatg OF Facdpedi NO-LOCK,
    FIRST Almsfami OF Almmmatg NO-LOCK,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXDSF"
        AND FacTabla.Codigo = TRIM(pCodDiv) + '|' + TRIM(Almsfami.codfam) + '|' + TRIM(Almsfami.subfam)
        AND FacTabla.Nombre <> "":
    /* Transformamos la cantidad en unidad base a cantidad en unidad de dcto x volumen */
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
        AND Almtconv.Codalter = FacTabla.Nombre
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
            '        Unidad Base:' Almmmatg.UndBas SKIP
            'Unidad de Sub-Linea:' FacTabla.Nombre SKIP(1)
            'SE CONTINUARÁ CON OTRO ARTÍCULO' SKIP(2)
            '*** Avisar a Sistemas ***'
            VIEW-AS ALERT-BOX WARNING TITLE "DESCUENTO POR VOLUMEN POR LINEA".
        FIND FIRST ErroresxLinea WHERE ErroresxLinea.codfam = Almmmatg.codfam
            AND ErroresxLinea.subfam = Almmmatg.subfam NO-ERROR.
        IF NOT AVAILABLE ErroresxLinea THEN CREATE ErroresxLinea.
        ASSIGN
            ErroresxLinea.codfam = Almmmatg.codfam
            ErroresxLinea.subfam = Almmmatg.subfam.
        NEXT.
    END.
    ASSIGN
        F-FACTOR = Almtconv.Equival.
    /* ******************************************************************************* */
    FIND FIRST ResumenxLinea WHERE ResumenxLinea.codfam = Almmmatg.codfam
        AND ResumenxLinea.subfam = Almmmatg.subfam NO-ERROR.
    IF NOT AVAILABLE ResumenxLinea THEN CREATE ResumenxLinea.
    ASSIGN
        ResumenxLinea.codfam = Almmmatg.codfam
        ResumenxLinea.subfam = Almmmatg.subfam
        ResumenxLinea.canped = ResumenxLinea.canped + (facdpedi.canped * facdpedi.factor / f-Factor).
END.
/* Eliminamos las lineas con errores */
FOR EACH ErroresxLinea:
    FIND ResumenxLinea WHERE ResumenxLinea.codfam = ErroresxLinea.codfam
        AND ResumenxLinea.subfam = ErroresxLinea.subfam
        NO-ERROR.
    IF AVAILABLE ResumenxLinea THEN DELETE ResumenxLinea.
END.

PRINCIPAL:
FOR EACH ResumenxLinea, 
    FIRST Almsfami NO-LOCK WHERE Almsfami.codcia = s-codcia
        AND Almsfami.codfam = ResumenxLinea.codfam
        AND Almsfami.subfam = ResumenxLinea.subfam,
    FIRST FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
        AND FacTabla.Tabla = "DVXDSF"
        AND FacTabla.Codigo = TRIM(pCodDiv) + '|' + TRIM(Almsfami.codfam) + '|' + TRIM(Almsfami.subfam):
    /* Buscamos descuento promocional y volumen */
    ASSIGN
        x-DctoPromocional = 0
        x-DctoxVolumen = 0
        x-Rango = 0
        X-CANTI = ResumenxLinea.canped.
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
    /* ********************************************************** */
    /* RHC 28/10/2013 SE VA A MANTENER EL PRECIO DE LA COTIZACION */
    /* ********************************************************** */
    IF x-DctoxVolumen > 0 THEN DO:
        /* ********************************************************** */
        /* RHC 23/12/2017 Expo ENERO Lo tomamos como un descuento mas */
        /* ********************************************************** */
        IF s-TpoPed = "E" /*AND LOOKUP(pCodDiv, '10015,10067,20060') > 0*/ THEN DO:
            /* ********************************************************************************************** */
            /* Recalculamos todos los Items */
            /* ********************************************************************************************** */
            FOR EACH Facdpedi OF Faccpedi, 
                FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = ResumenxLinea.codfam 
                    AND Almmmatg.subfam = ResumenxLinea.subfam:
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen
                    X-TIPDTO = "DVXDSF".
                ASSIGN 
                    Facdpedi.PorDto  = 0
                    Facdpedi.PorDto2 = 0            /* el precio unitario */
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
            NEXT PRINCIPAL.
        END.
        /* ********************************************************** */
        /* ********************************************************** */
        FOR EACH Facdpedi OF Faccpedi, 
            FIRST Almmmatg OF Facdpedi NO-LOCK WHERE Almmmatg.codfam = ResumenxLinea.codfam 
                AND Almmmatg.subfam = ResumenxLinea.subfam:
            /* ********************************************************************************************** */
            /* RHC 19/10/2015 Solo para CanalVenta = "FER" y lineas 011 y 013 se va a acumular los descuentos
                Promocional y Volumen LISTA POR DIVISION */
            /* ********************************************************************************************** */
            ASSIGN
                x-DctoPromocional = 0.
            IF GN-DIVI.CanalVenta = "FER" 
                AND LOOKUP(Almmmatg.CodFam, "011,013") > 0
                AND NOT (Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "014")
                THEN DO:
                /* Buscamos el descuento promocional en la lista por división */
                FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia
                    AND VtaListaMay.coddiv = pCodDiv
                    AND VtaListaMay.codmat = Facdpedi.codmat
                    NO-LOCK NO-ERROR.
                IF AVAILABLE VtaListaMay AND TODAY >= VtaListaMay.PromFchD AND TODAY <= VtaListaMay.PromFchH
                    THEN x-DctoPromocional = VtaListaMay.PromDto.
            END.
            /* ********************************************************************************************** */
            /* Recalculamos todos los Items */
            /* ********************************************************************************************** */
            ASSIGN
                F-PREBAS = Almmmatg.PreVta[1]       /* OJO => Se cambia Precio Base */
                Y-DSCTOS = ( 1 - (1 - x-DctoxVolumen / 100) * (1 - x-DctoPromocional / 100) ) * 100     /* <<<<<<<<<< OJO <<<<<< */
                X-TIPDTO = "DVXDSF".
            IF Gn-Divi.VentaMayorista = 2 THEN DO:  /* OJO: Lista por División */
                FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = pCodDiv NO-LOCK NO-ERROR.
                F-PreBas = VtaListaMay.PreOfi.
            END.
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
            F-PREVTA = F-PREBAS.
            /************************************************/
            RUN BIN/_ROUND1(F-PREVTA,s-NRODEC,OUTPUT F-PREVTA).
            /************************************************/
            ASSIGN 
                Facdpedi.PorDto  = 0
                Facdpedi.PorDto2 = 0            /* el precio unitario */
                Facdpedi.Por_Dsctos[2] = 0      /* del administrador */
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
         HEIGHT             = 3.65
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


