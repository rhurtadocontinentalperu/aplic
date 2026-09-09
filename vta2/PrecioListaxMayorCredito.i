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

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.

/* FACTOR DE EQUIVALENCIA (OJO: La s-UndVta ya debe tener un valor cargado) */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
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
    FIND FIRST ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc.
END.
ELSE DO:        /* TERCEROS */
    FIND FIRST ClfClie WHERE ClfClie.Categoria = X-CLFCLI2 NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc1.
END.
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
/************ Descuento Promocional ************/ 

IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoPro OR
     gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    THEN DO:
    {&Promocional}
END.
/*************** Descuento por Volumen ****************/
IF AVAILABLE gn-convt AND 
    (gn-convt.totdias <= pDiasDctoVol OR
     gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
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
    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
    X-TIPDTO = "".

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
                F-PREBAS = {&PreVta}            /* OJO => Se cambia Precio Base */
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen    /* OJO */
                    X-TIPDTO = "VOL".
        END.
        /* Si no hay descuento promocional ni volumen => x clasificación y venta */
        IF Y-DSCTOS = 0 THEN F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
    END.
    WHEN x-Libre_C01 = "A" THEN DO:     /* Descuentos Acumulados */
        F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
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
/* RHC 22/07/2016 Caso de Transferencia Gratuita */
/* RHC 27/04/2017 Bloqueado a solicitud de Carmen Ayala y aprobado por Luis Figueroa */
/* IF LOOKUP(S-CNDVTA, "899,900") > 0 AND Almmmatg.CtoTot > 0 */
/*     THEN F-PreBas = Almmmatg.CtoTot.                       */
/* ********************************************* */
PRECIOBASE:
DO:
    /* RHC 30/03/2015 CONTRATO MARCO: SU LISTA DE PRECIOS ES SIEMPRE EN SOLES */
    IF s-TpoPed = "M" THEN DO:
        IF S-CODMON = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        IF S-CODMON = 2 THEN ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
        LEAVE PRECIOBASE.
    END.
    /* ********************************************************************** */
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
    END.
END.
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/************************************************/
/*RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).*/
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
         HEIGHT             = 4.62
         WIDTH              = 49.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


