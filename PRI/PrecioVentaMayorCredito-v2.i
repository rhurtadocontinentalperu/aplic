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
    Notes       : Por aquí no pasa UTILEX
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.

/* FACTOR DE EQUIVALENCIA (OJO: La s-UndVta ya debe tener un valor cargado) */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        '   Unidad Stock: ' + Almmmatg.UndStk + CHR(10) +
        'Unidad de Venta: ' + s-UndVta.
    RETURN "ADM-ERROR".
END.
/* VALORES POR DEFECTO */
ASSIGN
    F-FACTOR = Almtconv.Equival     /* Equivalencia */
    s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */
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
FIND FIRST Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND Dsctos.clfCli = Almmmatg.Chr__02    /* P: propio o T: terceros */
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A n DIAS  */
/* ********************************************************************************* */
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0.
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.

/* ************************************************************************************** */
/************ Descuento Promocional ************/ 
/* ************************************************************************************** */
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoPro OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    {&Promocional}
END.
/* ************************************************************************************** */
/*************** Descuento por Volumen ****************/
/* ************************************************************************************** */
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    X-CANTI = X-CANPED * F-FACTOR.  /* En unidades de stock */
    DO J = 1 TO 10:
        IF X-CANTI >= {&Tabla}.DtoVolR[J] AND {&Tabla}.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = {&Tabla}.DtoVolR[J].
            IF X-RANGO <= {&Tabla}.DtoVolR[J] THEN DO:
                ASSIGN
                    X-RANGO  = {&Tabla}.DtoVolR[J]
                    x-DctoxVolumen = {&Tabla}.DtoVolD[J].
            END.   
        END.   
    END.
END.
/* ************************************************************************************** */
/* RHC 15/09/2020 Descuento por volumen por división */
/* ************************************************************************************** */
DEF VAR x-Old-Vol-Div AS DEC NO-UNDO. 
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    x-Old-Vol-Div = 0. 
    FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
        VtaDctoVol.CodDiv = s-CodDiv AND
        VtaDctoVol.CodMat = s-CodMat AND
        (TODAY >= VtaDctoVol.FchIni AND TODAY <= VtaDctoVol.FchFin)
        BY VtaDctoVol.FchIni:
        X-CANTI = X-CANPED * F-FACTOR.
        x-Rango = 0.
        DO J = 1 TO 10:
            IF X-CANTI >= VtaDctoVol.DtoVolR[J] AND VtaDctoVol.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = VtaDctoVol.DtoVolR[J].
                IF X-RANGO <= VtaDctoVol.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = VtaDctoVol.DtoVolR[J]
                        x-DctoxVolumen = VtaDctoVol.DtoVolD[J].
                END.
            END.
        END.
        x-DctoxVolumen = MAXIMUM(x-DctoxVolumen, x-Old-Vol-Div). 
        x-Old-Vol-Div = x-DctoxVolumen.
    END.
END.
/* *************************************** */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* *************************************** */
IF x-FlgDtoClfCli = NO THEN MaxCat = 0.     /* Descuento por Clasificación del cliente */
IF x-FlgDtoCndVta = NO THEN MaxVta = 0.     /* Descuento por Condicion de Venta */
IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.
/* *********************************** */
/* PRECIO BASE, DE VENTA Y DESCUENTOS */
/* *********************************** */
ASSIGN
    F-PREBAS = {&Tabla}.PreOfi      /* POR DEFECTO */
    F-PREVTA = {&Tabla}.PreOfi      /* POR DEFECTO */
    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
    X-TIPDTO = "".

CASE TRUE:
    WHEN x-TpoDcto = "E" THEN DO:      /* Descuentos Excluyentes */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                F-PREVTA = {&PreVta}            /* OJO => Se cambia Precio Base */
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen    /* OJO */
                    X-TIPDTO = "VOL".
            /* RHC 11/08/2020 Se toma el mejor precio: Cesar Camus */
            IF F-PREVTA * (1 - (x-DctoPromocional / 100)) < F-PREVTA * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                        Y-DSCTOS = x-DctoPromocional    /* OJO */
                        X-TIPDTO = "PROM".
            ELSE ASSIGN
                        Y-DSCTOS = x-DctoxVolumen    /* OJO */
                        X-TIPDTO = "VOL".
        END.
        /* Si no hay descuento promocional ni volumen => x clasificación y venta */
        IF Y-DSCTOS = 0 THEN F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
    END.
    WHEN x-TpoDcto = "A" THEN DO:     /* Descuentos Acumulados */
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen   /* OJO */
                    X-TIPDTO = "VOL".
            /* RHC 11/08/2020 Se toma el mejor precio: Cesar Camus */
            IF F-PREVTA * (1 - (x-DctoPromocional / 100)) < F-PREVTA * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                        Y-DSCTOS = x-DctoPromocional    /* OJO */
                        X-TIPDTO = "PROM".
            ELSE ASSIGN
                        Y-DSCTOS = x-DctoxVolumen    /* OJO */
                        X-TIPDTO = "VOL".
        END.
        
    END.
END CASE.
/* ******************************** */
/* PRECIO BASE A LA MONEDA DE VENTA */
/* ******************************** */
PRECIOBASE:
DO:
    CASE TRUE:
        WHEN s-CodMon = 1 AND Almmmatg.MonVta = 2 THEN F-PREVTA = F-PREVTA * x-TpoCmbVenta.
        WHEN s-CodMon = 2 AND Almmmatg.MonVta = 1 THEN F-PREVTA = F-PREVTA / x-TpoCmbCompra.
    END CASE.
    CASE TRUE:
        WHEN s-CodMon = 1 AND Almmmatg.MonVta = 2 THEN F-PREBAS = F-PREBAS * x-TpoCmbVenta.
        WHEN s-CodMon = 2 AND Almmmatg.MonVta = 1 THEN F-PREBAS = F-PREBAS / x-TpoCmbCompra.
    END CASE.
END.
/* DO:                                                                                  */
/*     /* RHC 30/03/2015 CONTRATO MARCO: SU LISTA DE PRECIOS ES SIEMPRE EN SOLES */     */
/*     IF s-TpoPed = "M" THEN DO:                                                       */
/*         IF S-CODMON = 1 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.              */
/*         IF S-CODMON = 2 THEN ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) /** F-FACTOR*/. */
/*         LEAVE PRECIOBASE.                                                            */
/*     END.                                                                             */
/*     /* ********************************************************************** */     */
/*     IF S-CODMON = 1 THEN DO:                                                         */
/*         IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.       */
/*         ELSE ASSIGN F-PREVTA = F-PREVTA * S-TPOCMB /** F-FACTOR*/.                   */
/*     END.                                                                             */
/*     IF S-CODMON = 2 THEN DO:                                                         */
/*         IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.       */
/*         ELSE ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) /** F-FACTOR*/.                 */
/*     END.                                                                             */
/*     IF S-CODMON = 1 THEN DO:                                                         */
/*         IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.       */
/*         ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.                   */
/*     END.                                                                             */
/*     IF S-CODMON = 2 THEN DO:                                                         */
/*         IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.       */
/*         ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.                 */
/*     END.                                                                             */
/* END.                                                                                 */
/************************************************/
F-PREVTA = F-PREVTA * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
RUN lib/RedondearMas (F-PREBAS, X-NRODEC, OUTPUT F-PREBAS).
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
/************************************************/

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
         HEIGHT             = 4.81
         WIDTH              = 53.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


