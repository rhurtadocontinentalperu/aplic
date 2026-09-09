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
    .
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
IF AVAILABLE gn-convt 
    AND (gn-convt.totdias <= pDiasDctoVol OR gn-convt.libre_l02 = YES)      /* Condición unica campaña (404) */
    AND AVAILABLE {&Tabla}
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

/* Ic - 28Nov2022, Correo de Cesar Canus
    Por favor ampliar la regla de negocio para propios 
    Acabo de conversar con Gloria y no le afecta en su gestión esta regla  de negocio que funciona muy bien con Terceros
    
    Gracias        
*/

/* *************************************** */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* *************************************** */
IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.
/* *********************************** */
/* PRECIO BASE, DE VENTA Y DESCUENTOS */
/* *********************************** */

ASSIGN
    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
    X-TIPDTO = "".

CASE TRUE:
    WHEN x-Libre_C01 = "" THEN DO:      /* Descuentos Excluyentes */
        /* Orden de Prioridad:
            Descuento por Volumen 
            Descuento Promocional
            Descuento por Clasificacion y Condicion 
            */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
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
    END.
    WHEN x-Libre_C01 = "A" THEN DO:     /* Descuentos Acumulados */
        IF x-DctoPromocional > 0 OR x-DctoxVolumen > 0 THEN DO:
            ASSIGN
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            IF x-DctoxVolumen > 0 THEN 
                ASSIGN
                    Y-DSCTOS = x-DctoxVolumen   /* OJO */
                    X-TIPDTO = "VOL".
        END.
    END.
END CASE.

/* ******************************** */
/* PRECIO BASE A LA MONEDA DE VENTA */
/* ******************************** */
PRECIOBASE:
DO:
    IF S-CODMON = 1 THEN DO:
        IF x-MonVta = 1 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.
        ELSE ASSIGN F-PREVTA = F-PREVTA * S-TPOCMB /** F-FACTOR*/.
    END.
    IF S-CODMON = 2 THEN DO:
        IF x-MonVta = 2 THEN ASSIGN F-PREVTA = F-PREVTA /** F-FACTOR*/.
        ELSE ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) /** F-FACTOR*/.
    END.
    IF S-CODMON = 1 THEN DO:
        IF x-MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB /** F-FACTOR*/.
    END.
    IF S-CODMON = 2 THEN DO:
        IF x-MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS /** F-FACTOR*/.
        ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) /** F-FACTOR*/.
    END.
END.
F-PREVTA = F-PREVTA * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
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
         WIDTH              = 69.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


