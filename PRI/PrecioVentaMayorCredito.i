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
/*     IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP */
/*         '   Unidad Stock:' Almmmatg.UndStk SKIP                                                                        */
/*         'Unidad de Venta:' s-UndVta                                                                                    */
/*         VIEW-AS ALERT-BOX ERROR.                                                                                       */
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
/* ***********************************************************************/
/* 21/06/2022: Se fuerza a TERCEROS en caso de línea 011: Daniel Llican  */
/* ***********************************************************************/
/* 15/07/2022: Camus, la línea 011 siempre parte del precio de lista */
/* IF Almmmatg.CodFam = '011' THEN DO:                                    */
/*     MaxCat = 0.                                                        */
/*     FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI2 NO-LOCK NO-ERROR. */
/*     IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc1.                    */
/* END.                                                                   */
/* ***********************************************************************/
 /* *************************************************** */
/* DESCUENTO POR CONDICION DE VENTA Y TIPO DE PRODUCTO */
/* *************************************************** */
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.
/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A 30 DIAS */                        
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
DEFINE VAR pCantidad AS DECI INIT 0 NO-UNDO.
/* DEFINE VAR hProc AS HANDLE NO-UNDO.           */
/* RUN pri/pri-librerias.p PERSISTENT SET hProc. */
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    X-CANTI = X-CANPED * F-FACTOR.
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
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    DEF VAR x-Old-Vol-Div AS DEC NO-UNDO. 
    x-Old-Vol-Div = 0. 
    FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
        VtaDctoVol.CodDiv = s-CodDiv AND
        VtaDctoVol.CodMat = s-CodMat AND
        (TODAY >= VtaDctoVol.FchIni AND TODAY <= VtaDctoVol.FchFin)
        BY VtaDctoVol.FchIni:
        X-CANTI = X-CANPED * F-FACTOR.
        /* ************************************************************************************** */
        /* 10/05/2022 Agregamos los facturado */
        /* ************************************************************************************** */
        X-CANTI = X-CANTI + pCantidad.
        /* ************************************************************************************** */
        /* ************************************************************************************** */
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
/* DELETE PROCEDURE hProc. */
/* ************************************************************************************** */
/* RHC 25/02/2020 Caso VIP HUANCAYO */
/* ************************************************************************************** */
IF s-CodDiv = '00072' THEN DO:
    FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia AND
        VtaTabla.Tabla = "CLIENTE_VIP_CONTI" AND
        VtaTabla.Llave_c1 = s-CodCli
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        /* Buscamos Descuento por Escalas */
        IF AVAILABLE gn-convt AND (gn-convt.totdias <= pDiasDctoVol OR
                                   gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
            THEN DO:
            FOR EACH PriDctoVol NO-LOCK WHERE PriDctoVol.CodCia = s-CodCia AND
                PriDctoVol.CodDiv = s-CodDiv AND
                PriDctoVol.CodMat = s-CodMat AND
                (TODAY >= PriDctoVol.FchIni AND TODAY <= PriDctoVol.FchFin)
                BY PriDctoVol.FchIni:
                X-CANTI = X-CANPED * F-FACTOR.
                DO J = 1 TO 10:
                    IF X-CANTI >= PriDctoVol.DtoVolR[J] AND PriDctoVol.DtoVolR[J] > 0  THEN DO:
                        IF X-RANGO  = 0 THEN X-RANGO = PriDctoVol.DtoVolR[J].
                        IF X-RANGO <= PriDctoVol.DtoVolR[J] THEN DO:
                            ASSIGN
                                X-RANGO  = PriDctoVol.DtoVolR[J]
                                x-DctoxVolumen = PriDctoVol.DtoVolD[J].
                            
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
/* ************************************************************************************** */

/* *************************************** */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* *************************************** */
IF x-FlgDtoClfCli = NO THEN MaxCat = 0.     /* Descuento por Clasificacion */
IF x-FlgDtoCndVta = NO THEN MaxVta = 0.     /* Descuento por Condicion de Venta */
IF x-FlgDtoClfCli = YES AND x-ClfCli = 'C' AND GN-DIVI.PorDtoClfCli > 0 
    THEN MaxCat = GN-DIVI.PorDtoClfCli.     /* Descuento especial Categoria C */
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
/* *********************************************************************************************************************** */
/* 15/07/2012: Cesar Camus: Si un producto no llega a la primera escala toma Precio lista = precio A en la línea fotocopia */
/* *********************************************************************************************************************** */
IF Almmmatg.CodFam = "011" THEN DO:
    MaxCat = 0.
    MaxVta = 0.
    F-PREBAS = {&PreVta}.
    F-PREVTA = {&PreVta}.
END.
/* *********************************************************************************************************************** */
/* *********************************************************************************************************************** */
CASE TRUE:
    WHEN x-Libre_C01 = "" THEN DO:      /* Descuentos Excluyentes */
        /* SOLO PARA LISTA DE PRECIOS POR DIVISION: GN-DIVI.VentaMayorista = 2 */
        IF GN-DIVI.VentaMayorista = 2
            AND x-DctoxVolumen = 0 
            AND x-DctoPromocional > 0 
            THEN F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
        /* Orden de Prioridad:
            Descuento por Volumen 
            Descuento Promocional
            Descuento por Clasificacion y Condicion 
            */
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
            IF Almmmatg.chr__02 = "T" THEN DO:
                IF F-PREVTA * (1 - (x-DctoPromocional / 100)) < F-PREVTA * (1 - (x-DctoxVolumen / 100))
                    THEN ASSIGN 
                    Y-DSCTOS = x-DctoPromocional    /* OJO */
                    X-TIPDTO = "PROM".
                ELSE ASSIGN
                    Y-DSCTOS = x-DctoxVolumen    /* OJO */
                    X-TIPDTO = "VOL".
            END.
            /* *************************************************** */
        END.
        /* Si no hay descuento promocional ni volumen => x clasificación y venta */
        IF Y-DSCTOS = 0 THEN F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
    END.
    WHEN x-Libre_C01 = "A" THEN DO:     /* Descuentos Acumulados */
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                /*F-PREVTA = {&PreVta}            /* OJO => Se cambia Precio Base */*/
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen   /* OJO */
                    X-TIPDTO = "VOL".
            /* RHC 20/10/2015 ACUMULATIVOS */
            /*Y-DSCTOS = ( 1 - (1 - x-DctoxVolumen / 100) * (1 - x-DctoPromocional / 100) ) * 100.*/
            /* *************************** */
        END.
    END.
END CASE.
/* ******************************** */
/* PRECIO BASE A LA MONEDA DE VENTA */
/* ******************************** */
PRECIOBASE:
DO:
    /* RHC 30/03/2015 CONTRATO MARCO: SU LISTA DE PRECIOS ES SIEMPRE EN SOLES */
    IF s-TpoPed = "M" THEN DO:
        IF S-CODMON = 1 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.
        IF S-CODMON = 2 THEN ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) /** F-FACTOR*/.
        LEAVE PRECIOBASE.
    END.
    /* ********************************************************************** */
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.
        ELSE ASSIGN F-PREVTA = F-PREVTA * S-TPOCMB /** F-FACTOR*/.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.
        ELSE ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) /** F-FACTOR*/.
    END.
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
    END.
END.
F-PREVTA = F-PREVTA * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/*MESSAGE 'uno f-prevta: ' f-prevta f-dsctos maxcat maxvta.*/
/************************************************/
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


