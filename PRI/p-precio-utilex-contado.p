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

DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-CodBco AS CHAR.
DEF INPUT PARAMETER s-Tarjeta AS CHAR.
DEF INPUT PARAMETER s-CodPro AS CHAR.
DEF INPUT PARAMETER s-NroVale AS CHAR.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* VARIABLES LOCALES */
DEF VAR s-MonVta LIKE Almmmatg.MonVta NO-UNDO.
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.

DEF VAR x-PreBase-Dcto AS DECI NO-UNDO.

/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

/* VARIABLES DESCUENTOS CALCULADOS */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 6 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 6 NO-UNDO.

/* CONTROL POR LISTA DE PRECIOS/DIVISION */
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Exluyenbres, acumulados o el mejor */
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv NO-LOCK.
/* *********************************************************************************************** */
/* CONTROL DE VIGENCIA DE LA LISTA */
/* *********************************************************************************************** */
IF GN-DIVI.Campo-Date[1] <> ? AND TODAY < GN-DIVI.Campo-Date[1] THEN DO:
    MESSAGE 'La lista de precios aún no está vigente' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
IF GN-DIVI.Campo-Date[2] <> ? AND TODAY > GN-DIVI.Campo-Date[2] THEN DO:
    MESSAGE 'La lista de precios ya no está vigente' VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
/* *********************************************************************************************** */
/* *********************************************************************************************** */
ASSIGN
    x-FlgDtoVol         = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    x-FlgDtoProm        = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    x-Libre_C01         = GN-DIVI.Libre_C01             /* Tipo de descuento */
    x-Ajuste-por-flete  = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */
/* Valores de x-Libre_c01:
"Prioridades Excluyentes"   ""
"Prioridades Acumuladas"    "A"
"Busca mejor precio"        "M"
*/

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Producto' s-CodMat 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

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
         WIDTH              = 54.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ASSIGN
    F-Factor = 1
    F-PreBas = Almmmatg.PreOfi.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
/* NOTA: 13/02/2013 Hasta la fecha SOLO se usa la Lista Mayorista General */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:     /* LISTA GENERAL */
        FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMinGn THEN DO:
            MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios minorista'
                VIEW-AS ALERT-BOX ERROR.
            RETURN "ADM-ERROR".
        END.
        ASSIGN 
            f-Factor = 1
            x-PreBase-Dcto = VtaListaMinGn.PreOfi
            F-PreBas = VtaListaMinGn.PreOfi.       /* Precio Lista Por Defecto */
        /* Valores por Defecto: De la Lista de Precios por División */
        IF VtaListaMinGn.CHR__01 > '' THEN ASSIGN s-UndVta = VtaListaMinGn.Chr__01.
    END.
    WHEN 2 THEN DO:
        MESSAGE 'NO definido' VIEW-AS ALERT-BOX ERROR.
        RETURN 'ADM-ERROR'.
    END.
END CASE.
IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
IF TRUE <> (s-UndVta > '') THEN DO:
    MESSAGE 'Producto' Almmmatg.CodMat 'NO definido la unidad de venta en la lista:' s-CodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/* Revisemos el factor de conversión */
IF Almmmatg.UndBas <> s-UndVta THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat
            'Unidad de venta:' s-UndVta VIEW-AS ALERT-BOX WARNING.
        RETURN "ADM-ERROR".
    END.
    f-Factor = Almtconv.Equival.
END.
/* *************************************************************************** */
/* CONFIGURACION DE PRECIOS */
/* *************************************************************************** */
/* Si no ubica una configuración toma por defecto la de la división */
FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
    VtaDTabla.Tabla = 'CFGLP' AND
    VtaDTabla.Llave = s-CodDiv AND
    VtaDTabla.Tipo = Almmmatg.CodFam:
    IF Almmmatg.SubFam = VtaDTabla.Libre_c01 THEN NEXT.     /* Subfamilia (-) */
    IF VtaDTabla.LlaveDetalle > '' AND Almmmatg.SubFam <> VtaDTabla.LlaveDetalle THEN NEXT. /* Subfamilia (+) */
    /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
    x-FlgDtoVol    = VtaDTabla.Libre_l03.
    x-FlgDtoProm   = VtaDTabla.Libre_l04.
    x-Libre_C01    = VtaDTabla.Libre_c02.   /* "" Excluyentes, "A" acumulados "M" mejor precio */
    LEAVE.
END.

/* CASE gn-divi.VentaMinorista:                                                                  */
/*     WHEN 1 THEN DO:     /* LISTA GENERAL */                                                   */
/*         FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.                                */
/*         IF NOT AVAILABLE VtaListaMinGn THEN DO:                                               */
/*             MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios minorista' */
/*                 VIEW-AS ALERT-BOX ERROR.                                                      */
/*             RETURN "ADM-ERROR".                                                               */
/*         END.                                                                                  */
/*         ASSIGN                                                                                */
/*             f-Factor = 1                                                                      */
/*             x-PreBase-Dcto = VtaListaMinGn.PreOfi                                             */
/*             F-PreBas = VtaListaMinGn.PreOfi.       /* Precio Lista Por Defecto */             */
/*         ASSIGN                                                                                */
/*             s-UndVta = VtaListaMinGn.Chr__01.                                                 */
/*         RUN Precio-Empresa.                                                                   */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".                                */
/*     END.                                                                                      */
/*     WHEN 2 THEN DO:                                                                           */
/*         RUN Precio-Division.                                                                  */
/*         IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".                                */
/*     END.                                                                                      */
/* END CASE.                                                                                     */

/* *************************************************************************** */
/* CALCULAMOS EL PRECIO DE VENTA FINAL */
/* *************************************************************************** */
RUN Precio-de-Venta.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
/* *************************************************************************** */
/* *************************************************************************** */

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Precio-de-Venta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-de-Venta Procedure 
PROCEDURE Precio-de-Venta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR j AS INT NO-UNDO.
DEF VAR x-Canti AS DEC NO-UNDO.
DEF VAR x-Rango AS DEC NO-UNDO.

/* FACTOR DE EQUIVALENCIA (OJO: La s-UndVta ya debe tener un valor cargado) */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

/* VALORES POR DEFECTO */
ASSIGN
    F-FACTOR = Almtconv.Equival     /* Equivalencia */
    s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */
/* ********************************************************************************* */
/* DESCUENTOS PROMOCIONALES Y POR VOLUMEN: SOLO SI EL VENCIMIENTO ES MENOR A 30 DIAS */                        
/* ********************************************************************************* */
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0.
/* ********************************************************************************* */
/************ Descuento Promocional ************/ 
/* ********************************************************************************* */
DEF VAR x-Old-Descuento LIKE x-DctoPromocional NO-UNDO.
/* Tomamos el mayor descuento */
x-Old-Descuento = 0.
FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = s-CodCia AND
    VtaDctoPromMin.CodDiv = s-CodDiv AND 
    VtaDctoPromMin.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoPromMin.FchIni AND TODAY <= VtaDctoPromMin.FchFin):
    /* Solo en caso de EVENTOS existe el VIP, MR */
    x-DctoPromocional = VtaDctoPromMin.Descuento. 
    x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento).
    x-Old-Descuento = x-DctoPromocional.
END.
/* ********************************************************************************* */
/*************** Descuento por Volumen ****************/
/* ********************************************************************************* */
/* Tomamos el mayor descuento */
x-Old-Descuento = 0.
FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
    VtaDctoVol.CodDiv = s-CodDiv AND 
    VtaDctoVol.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoVol.FchIni AND TODAY <= VtaDctoVol.FchFin):
    X-CANTI = X-CANPED * F-FACTOR.
    X-RANGO = 0.
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
    x-DctoxVolumen = MAXIMUM(x-DctoxVolumen, x-Old-Descuento).
    x-Old-Descuento = x-DctoxVolumen.
END.
/* ********************************************************************************* */
/* DEPURAMOS LOS PORCENTAJES DE DESCUENTOS */
/* ********************************************************************************* */
IF x-FlgDtoVol  = NO THEN x-DctoxVolumen    = 0.
IF x-FlgDtoProm = NO THEN x-DctoPromocional = 0.
/* *********************************** */
/* PRECIO BASE, DE VENTA Y DESCUENTOS */
/* *********************************** */
/* Se toma el mejor descuento */
ASSIGN
    F-DSCTOS = 0                    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0                    /* Dcto por Volumen o Promocional */
    Z-DSCTOS = 0
    X-TIPDTO = "".
IF x-DctoPromocional <> 0 OR x-DctoxVolumen <> 0 THEN DO:
    ASSIGN
        F-PREBAS = x-PreBase-Dcto.      /* OJO => Se cambia Precio Base */
    IF x-DctoPromocional > x-DctoxVolumen THEN DO:
        ASSIGN
            Y-DSCTOS = x-DctoPromocional    /* OJO */
            X-TIPDTO = "PROM".
    END.
    ELSE DO:
        ASSIGN
            Y-DSCTOS = x-DctoxVolumen   /* OJO */
            X-TIPDTO = "VOL".
    END.
END.
/* ******************************** */
/* PRECIO BASE A LA MONEDA DE VENTA */
/* ******************************** */
PRECIOBASE:
DO:
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
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
/************************************************/
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
            
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Empresa) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Empresa Procedure 
PROCEDURE Precio-Empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.

/* RHC 12.06.08 tipo de cambio de la familia */
ASSIGN
    s-TpoCmb = Almmmatg.TpoCmb
    s-MonVta = Almmmatg.MonVta.

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF s-MonVta = 1
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMinGn.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF s-MonVta = 2
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMinGn.PreOfi / S-TPOCMB).
END.
/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* ********************************************************************************* */
/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* ********************************************************************************* */
/************ Descuento Promocional ************/ 
/* ********************************************************************************* */
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 6 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 6 NO-UNDO.
DEF VAR x-Old-Descuento LIKE x-DctoPromocional NO-UNDO.

/* Tomamos el mayor descuento */
ASSIGN
    x-DctoPromocional = 0
    x-DctoxVolumen = 0
    x-Old-Descuento = 0.
ASSIGN
    Y-DSCTOS = 0
    Z-DSCTOS = 0.
FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND
    VtaDctoProm.CodDiv = s-CodDiv AND 
    VtaDctoProm.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin):
    x-DctoPromocional = VtaDctoProm.Descuento. 
    x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento).
    x-Old-Descuento = x-DctoPromocional.
END.
Y-DSCTOS = x-DctoPromocional.
/* ********************************************************************************* */
/*************** Descuento por Volumen ****************/
/* ********************************************************************************* */
/* Tomamos el mayor descuento */
x-Old-Descuento = 0.
FOR EACH VtaDctoVol NO-LOCK WHERE VtaDctoVol.CodCia = s-CodCia AND
    VtaDctoVol.CodDiv = s-CodDiv AND 
    VtaDctoVol.CodMat = Almmmatg.CodMat AND
    (TODAY >= VtaDctoVol.FchIni AND TODAY <= VtaDctoVol.FchFin):
    X-CANTI = X-CANPED * F-FACTOR.
    X-RANGO = 0.
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
    x-DctoxVolumen = MAXIMUM(x-DctoxVolumen, x-Old-Descuento).
    x-Old-Descuento = x-DctoxVolumen.
END.
Z-DSCTOS = x-DctoxVolumen.
/* ********************************************************************************* */

IF Y-DSCTOS <> 0 OR Z-DSCTOS <> 0 THEN DO:
    IF Y-DSCTOS > Z-DSCTOS THEN DO:
        /* DESCUENTO PROMOCIONAL */
        IF GN-DIVI.FlgDtoProm = YES THEN DO:
            ASSIGN
                F-DSCTOS = 0
                F-PREVTA = VtaListaMinGn.PreOfi
                X-TIPDTO = "PROM".
            IF s-Monvta = 1 THEN
                ASSIGN 
                X-PREVTA1 = F-PREVTA
                X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
            ELSE
                ASSIGN 
                    X-PREVTA2 = F-PREVTA
                    X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
        END.
    END.
    ELSE DO:
        ASSIGN
            F-DSCTOS = 0
            F-PREVTA = VtaListaMinGn.PreOfi
            X-TIPDTO = "VOL".
        IF s-MonVta = 1 THEN
            ASSIGN 
            X-PREVTA1 = F-PREVTA
            X-PREVTA2 = ROUND(F-PREVTA / s-TpoCmb,6).
        ELSE
            ASSIGN 
                X-PREVTA2 = F-PREVTA
                X-PREVTA1 = ROUND(F-PREVTA * s-TpoCmb,6).
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
        IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1.
        ELSE F-PREBAS = X-PREVTA2.     
    END.    
END.
/* *********************************** */
/*RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).*/
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
/* *********************************** */
/* DESCUENTOS ADICIONALES POR DIVISION */
ASSIGN
    z-Dsctos = 0.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

