&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM_FINAL NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM_MARCO NO-UNDO LIKE FacDPedi.



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

DEF SHARED VAR s-codcia AS INTE.
DEF SHARED VAR s-coddiv AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.

/* PARAMETROS DE ENTRADA */
/* La lista completa de artículos */
DEF INPUT-OUTPUT PARAMETER TABLE FOR ITEM.
DEF INPUT PARAMETER pcCodDiv AS CHAR.
DEF INPUT PARAMETER pcCodCli AS CHAR.
DEF INPUT PARAMETER pcFmaPgo AS CHAR.
DEF INPUT PARAMETER pcTpoPed AS CHAR.       /* E: expolibreria */
DEF INPUT PARAMETER piCodMon AS INTE.
DEF INPUT PARAMETER s-NroDec AS INTE.

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* 1.- Limpiar ITEM para recibir datos */
/* DO TRANSACTION:                                                                             */
/*     FOR EACH ITEM EXCLUSIVE-LOCK:                                                           */
/*         /* CATALOGO DEL PRODUCTO */                                                         */
/*         FIND FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia                                */
/*             AND Almmmatg.codmat = ITEM.codmat NO-LOCK NO-ERROR.                             */
/*         IF NOT AVAILABLE Almmmatg THEN DO:                                                  */
/*             pMensaje = 'Producto ' + ITEM.CodMat + ' NO registrado en el catálogo general'. */
/*             RETURN "ADM-ERROR".                                                             */
/*         END.                                                                                */
/*         ASSIGN                                                                              */
/*             ITEM.PreUni = 0                                                                 */
/*             ITEM.Por_Dsctos[1] = 0                                                          */
/*             ITEM.Por_Dsctos[2] = 0                                                          */
/*             ITEM.Por_Dsctos[3] = 0                                                          */
/*             .                                                                               */
/*     END.                                                                                    */
/* END.                                                                                        */

/* 2.- Definimos parámetros generales de cálculo */
DEF VAR gFlgDtoVol     LIKE GN-DIVI.FlgDtoVol  NO-UNDO.
DEF VAR gFlgDtoProm    LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR gLibre_C01     LIKE GN-DIVI.Libre_C01  NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */
DEF VAR gAjuste-por-flete AS LOG NO-UNDO.

/* CONFIGURACIONES DE LA DIVISION */
/* OJO: Configuración de la LISTA DE PRECIOS */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = pcCodDiv NO-LOCK.
ASSIGN
    gFlgDtoVol = GN-DIVI.FlgDtoVol             /* Descuento por Volumen */
    gFlgDtoProm = GN-DIVI.FlgDtoProm           /* Descuento Promocional */
    gLibre_C01 = GN-DIVI.Libre_C01             /* Tipo de descuento */
    gAjuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */

/* CLIENTE */
IF pcCodCli > '' THEN DO:
    FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
        AND gn-clie.CodCli = pcCodCli
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gn-clie THEN DO:
        pMensaje = 'Cliente (' + pcCodCli + ') NO registrado' + CHR(10) +
            'Comunicarse con gestor del maestro de clientes'.
        RETURN 'ADM-ERROR'.
    END.
END.

DEF VAR gDiasDctoVol AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento por Volumen (hasta 60 dias ) */
DEF VAR gDiasDctoPro AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento Promocional (hasta 60 dias ) */

DEF VAR pDiasDctoVol AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento por Volumen (hasta 60 dias ) */
DEF VAR pDiasDctoPro AS INT INIT 60 NO-UNDO.    /* Tope Para % Descuento Promocional (hasta 60 dias ) */

/* *************************************************************************** */
/* CLASIFICACION DEL CLIENTE POR DEFECTO */
/* *************************************************************************** */
DEF VAR x-ClfCli  AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR INIT "C" NO-UNDO.      /* Clasificacion para productos de terceros */

ASSIGN
    x-ClfCli  = "C"         /* Valores por defecto */
    x-ClfCli2 = "C".

IF AVAIL gn-clie AND gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.

DEF VAR s-porigv AS DEC NO-UNDO.

FIND FIRST FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK.
s-PorIgv = FacCfgGn.PorIgv.

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
   Temp-Tables and Buffers:
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM_FINAL T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: ITEM_MARCO T "?" NO-UNDO INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


DEF VAR cClfCli AS CHAR NO-UNDO.
DEF VAR cCodMat AS LONGCHAR NO-UNDO.
DEF VAR cFmaPgo AS LONGCHAR NO-UNDO.


/* Actualizamos precios */
CASE TRUE:
    WHEN pcTpoPed = "R" THEN DO:       /* CASO ESPECIAL -> REMATES */
        RUN Precio-Remate.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    WHEN pcTpoPed = "M" THEN DO:   /* CONTRATO MARCO */
        /* Se hace en dos partes:
            1. La parte del contrato marco 
            2. La parte de precio tienda 
            */
        RUN Precio-Contrato-Marco.
    END.
    WHEN pcTpoPed = "E" THEN DO:       /* EXPOLIBRERIA */
        RUN Precio-Expolibreria.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    OTHERWISE DO:
        RUN Precio-Tiendas.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Calculo-por-item-evento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-por-item-evento Procedure 
PROCEDURE Calculo-por-item-evento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcReturn AS LONGCHAR.
DEF INPUT PARAMETER iRegistro AS INTE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Formato de pcReturn
000752:13.3572:2:N,000751:10.780:1:Y
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<Contrato>[,...[,...]]
*/

{pri/pri-precio-mayorista.i}

FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia 
    AND VtaListaMay.coddiv = pcCodDiv
    AND VtaListaMay.codmat = ITEM.CodMat
    NO-LOCK NO-ERROR.

/* DEF VAR cCodMat AS CHAR NO-UNDO.                                                                               */
/* DEF VAR fPreUni  AS DECI NO-UNDO.                                                                              */
/* DEF VAR f-PreVta AS DECI NO-UNDO.                                                                              */
/* DEF VAR f-PreBas AS DECI NO-UNDO.                                                                              */
/* DEF VAR y-DSCTOS AS DECI NO-UNDO.                                                                              */
/* DEF VAR cTipDto AS CHAR NO-UNDO.                                                                               */
/* DEF VAR f-Factor AS DECI NO-UNDO.                                                                              */
/* DEF VAR f-FleteUnitario AS DECI NO-UNDO.                                                                       */
/* DEF VAR F-DSCTOS AS DECI NO-UNDO.                                                                              */
/* DEF VAR z-Dsctos AS DECI NO-UNDO.                                                                              */
/* DEF VAR x-TipDto AS CHAR NO-UNDO.                                                                              */
/* DEF VAR x-CanPed AS DECI NO-UNDO.                                                                              */
/* DEF VAR s-UndVta AS CHAR NO-UNDO.                                                                              */
/* DEF VAR s-CndVta AS CHAR NO-UNDO.                                                                              */
/* DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.                                                       */
/* DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.                                                       */
/* DEF VAR pCodDiv AS CHAR NO-UNDO.                                                                               */
/* pCodDiv = pcCodDiv.                                                                                            */
/* DEF VAR s-CodMon AS INTE NO-UNDO.                                                                              */
/* s-CodMon = piCodMon.                                                                                           */
/* DEF VAR x-MonVta AS INTE NO-UNDO.       /* Moneda de venta de la lista de precios */                           */
/* DEF VAR s-TpoCmb AS DECI NO-UNDO.                                                                              */
/* DEF VAR x-NroDec AS INTE NO-UNDO.                                                                              */
/* x-NroDec = s-NroDec.                                                                                           */
/*                                                                                                                */
/* DEF VAR x-FlgDtoVol     LIKE GN-DIVI.FlgDtoVol  NO-UNDO.                                                       */
/* DEF VAR x-FlgDtoProm    LIKE GN-DIVI.FlgDtoProm NO-UNDO.                                                       */
/* DEF VAR x-Libre_C01     LIKE GN-DIVI.Libre_C01  NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */     */
/* DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.                                                                     */
/*                                                                                                                */
/* cCodMat =         ENTRY(1,ENTRY(iRegistro,pcReturn),':').                                                      */
/* fPreUni = DECIMAL(ENTRY(2,ENTRY(iRegistro,pcReturn),':')).                                                     */
/* x-MonVta = INTEGER(ENTRY(3,ENTRY(iRegistro,pcReturn),':')).                                                    */
/* s-TpoCmb = DECIMAL(ENTRY(4,ENTRY(iRegistro,pcReturn),':')).                                                    */
/* s-CndVta = pcFmaPgo.                                                                                           */
/*                                                                                                                */
/* x-FlgDtoVol = gFlgDtoVol.                                                                                      */
/* x-FlgDtoProm = gFlgDtoProm.                                                                                    */
/* x-Libre_c01 = gLibre_C01.                                                                                      */
/* x-Ajuste-por-flete = gAjuste-por-flete.                                                                        */
/*                                                                                                                */
/* /* *************************************************************************** */                              */
/* /* Posicionamos registro en ITEM */                                                                            */
/* /* *************************************************************************** */                              */
/* FIND FIRST ITEM WHERE ITEM.codmat = cCodMat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                   */
/* IF NOT AVAILABLE ITEM THEN NEXT.                                                                               */
/* FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = cCodMat NO-LOCK.                          */
/* /* *************************************************************************** */                              */
/* /* PRECIO BASE Y UNIDAD DE VENTA */                                                                            */
/* /* *************************************************************************** */                              */
/* FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia                                                           */
/*     AND VtaListaMay.coddiv = pcCodDiv                                                                          */
/*     AND VtaListaMay.codmat = ITEM.CodMat                                                                       */
/*     NO-LOCK NO-ERROR.                                                                                          */
/*                                                                                                                */
/* ASSIGN                                                                                                         */
/*     F-FACTOR = ITEM.Factor                                                                                     */
/*     x-CanPed = ITEM.CanPed                                                                                     */
/*     s-UndVta = ITEM.UndVta                                                                                     */
/*     f-PreVta = ITEM.PreUni                                                                                     */
/*     f-PreBas = ITEM.PreBas                                                                                     */
/*     f-Dsctos = ITEM.PorDto                                                                                     */
/*     z-Dsctos = ITEM.Por_Dsctos[2]                                                                              */
/*     y-Dsctos = ITEM.Por_Dsctos[3]                                                                              */
/*     x-TipDto = ''.                                                                                             */
/*                                                                                                                */
/* /* Unidad de Venta */                                                                                          */
/* IF TRUE <> (s-UndVta > '') THEN DO:                                                                            */
/*     /*IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.*/                                      */
/*     IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.                                         */
/*     IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndStk.                                         */
/*     IF TRUE <> (s-UndVta > '') THEN DO:                                                                        */
/*         pMensaje = 'Producto: ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.                         */
/*         RETURN "ADM-ERROR".                                                                                    */
/*     END.                                                                                                       */
/* END.                                                                                                           */
/*                                                                                                                */
/* ASSIGN                                                                                                         */
/*     f-Factor = 1.                                                                                              */
/* /* Revisemos el factor de conversión */                                                                        */
/* FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND                                                    */
/*     Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.                                                             */
/* IF NOT AVAILABLE Almtconv THEN DO:                                                                             */
/*     pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) + */
/*         'Unidad de venta: ' + s-UndVta.                                                                        */
/*     RETURN "ADM-ERROR".                                                                                        */
/* END.                                                                                                           */
/* f-Factor = Almtconv.Equival.                                                                                   */

/* Definimos si es por contrato o no */
CASE TRUE:
    /* CONTRATO: OJO siempre en SOLES */
    WHEN ENTRY(7,ENTRY(iRegistro,pcReturn),':') = "Y" THEN DO:
        ASSIGN
            f-PreVta = fPreUni * f-Factor
            y-DSCTOS = 0
            x-TipDto = "CONTRATO".
        IF piCodMon = 1 THEN DO:
            IF x-MonVta = 1 THEN ASSIGN f-PreVta = f-PreVta.
            ELSE ASSIGN f-PreVta = f-PreVta * s-TPOCMB.
        END.
        IF piCodMon = 2 THEN DO:
            IF x-MonVta = 2 THEN ASSIGN f-PreVta = f-PreVta.
            ELSE ASSIGN f-PreVta = (f-PreVta / s-TPOCMB).
        END.
        ASSIGN
            f-PreBas = f-PreVta.
        /************************************************/
        RUN lib/RedondearMas (F-PREVTA, s-NRODEC, OUTPUT f-PREVTA).
        /************************************************/
    END.
    /* NO CONTRATO */
    OTHERWISE DO:
        ASSIGN
            F-PreVta = fPreUni * f-Factor      /* En unidades de venta */
            F-PreBas = f-PreVta.                /* Valor por Defecto */
        /* ****************************************************************************************** */
        /* CONFIGURACION DE PRECIOS EVENTO */
        /* ****************************************************************************************** */
        /* Si no ubica una configuración toma por defecto la de la división */
        FOR EACH VtaDTabla NO-LOCK WHERE VtaDTabla.CodCia = s-CodCia AND
            VtaDTabla.Tabla = 'CFGLP' AND
            VtaDTabla.Llave = pCodDiv AND
            VtaDTabla.Tipo = Almmmatg.CodFam:
            IF Almmmatg.SubFam = VtaDTabla.Libre_c01 THEN NEXT.     /* Subfamilia (-) */
            IF VtaDTabla.LlaveDetalle > '' AND Almmmatg.SubFam <> VtaDTabla.LlaveDetalle THEN NEXT. /* Subfamilia (+) */
            /* CALCULO DE PRECIO Y DESCUENTO POR PRODUCTO */
            x-FlgDtoVol    = VtaDTabla.Libre_l03.
            x-FlgDtoProm   = VtaDTabla.Libre_l04.
            x-Libre_C01    = VtaDTabla.Libre_c02.   /* "" Excluyentes, "A" acumulados */
            LEAVE.
        END.
        /* ****************************************************************************************** */
        /* Rutina única */
        /* ****************************************************************************************** */
        /*{pri/PrecioVentaMayorCreditoFlash.i ~*/
        {pri/unit-price-credit-sale.i ~
            &Tabla=VtaListaMay ~
            /*&PreVta=F-PREVTA ~*/
            &Promocional="~
            /* Tomamos el mayor descuento */ ~
            DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
            x-Old-Descuento = 0. ~
            FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
                VtaDctoProm.CodDiv = pCodDiv AND ~
                VtaDctoProm.CodMat = Almmmatg.CodMat AND ~
                VtaDctoProm.FlgEst = 'A' AND ~
                (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
                /* Solo en caso de EVENTOS existe el VIP, MR */ ~
                IF gn-divi.CanalVenta = 'FER' THEN DO: ~
                    CASE gn-clie.LocCli:  ~
                        WHEN 'VIP' THEN x-DctoPromocional = VtaDctoProm.DescuentoVIP.  ~
                        WHEN 'MR' THEN x-DctoPromocional = VtaDctoProm.DescuentoMR. ~
                        OTHERWISE x-DctoPromocional = VtaDctoProm.Descuento. ~
                    END CASE. ~
                END. ~
                ELSE DO: ~
                    x-DctoPromocional = VtaDctoProm.Descuento. ~
                END.
                x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
                x-Old-Descuento = x-DctoPromocional. ~
            END. ~
            " }
        /* *************************************************************************** */
        /* PRECIO CONTRATOS NO AFECTO A FLETE */
        /* *************************************************************************** */
        /* Determinamos el Flete Unitario */
        /* *************************************************************************** */
        /* 1ro. Factor Harold Segura */
        /* *************************************************************************** */
        RUN vtagn/flete-unitario-general-v01.p (cCodMat,
                                                pCodDiv,
                                                S-CODMON,
                                                f-Factor,
                                                OUTPUT f-FleteUnitario).
        /* *************************************************************************** */
        /* 2do. Factor Karin Rodhenberg */
        /* *************************************************************************** */
        RUN gn/factor-porcentual-flete-v3.p (INPUT pcoddiv, 
                                             INPUT cCodMat,
                                             INPUT-OUTPUT f-FleteUnitario, 
                                             INPUT pcTpoPed, 
                                             INPUT f-factor, 
                                             INPUT s-CodMon,
                                             INPUT f-PreVta).
    END.
END.            

/* TODAS LAS LISTAS AFECTAS A RECARGO */
/* ***************************************************************************************** */
/* 30/10/2023: Incremento de precio por RECARGO (papel fill) C.Camus */
/* ***************************************************************************************** */
RUN Recargo (INPUT cCodMat,
             INPUT s-CodMon,
             INPUT s-TpoCmb,
             INPUT-OUTPUT f-PreBas,
             INPUT-OUTPUT f-PreVta).

/* ***************************************************************************************** */
/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
/* ***************************************************************************************** */
ASSIGN z-Dsctos = 0.

/* ***************************************************************************************** */
/* OJO: Control de Precio Base */
F-PREBAS = F-PREVTA.
/* *************************************************************************** */

ASSIGN 
    ITEM.Factor = f-Factor
    ITEM.UndVta = s-UndVta
    ITEM.PreUni = F-PREVTA
    ITEM.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
    ITEM.PreBas = F-PreBas 
    ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
    ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
    ITEM.PorDto2 = 0            /* el precio unitario */
    ITEM.Por_Dsctos[2] = z-Dsctos
    ITEM.Por_Dsctos[3] = Y-DSCTOS 
    ITEM.AftIgv = Almmmatg.AftIgv
    ITEM.AftIsc = Almmmatg.AftIsc
    ITEM.ImpIsc = 0
    ITEM.ImpIgv = 0
    ITEM.Libre_c04 = x-TipDto.
/* ***************************************************************** */
{vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
/* ***************************************************************** */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Calculo-por-item-tienda) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Calculo-por-item-tienda Procedure 
PROCEDURE Calculo-por-item-tienda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pcReturn AS LONGCHAR.
DEF INPUT PARAMETER iRegistro AS INTE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Formato de pcReturn
000752:13.3572:2:N,000751:10.780:1:Y
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<Contrato>[,...[,...]]
*/

{pri/pri-precio-mayorista.i}

/* DEF VAR cCodMat AS CHAR NO-UNDO.                                                                               */
/* DEF VAR fPreUni  AS DECI NO-UNDO.                                                                              */
/* DEF VAR f-PreVta AS DECI NO-UNDO.                                                                              */
/* DEF VAR f-PreBas AS DECI NO-UNDO.                                                                              */
/* DEF VAR y-DSCTOS AS DECI NO-UNDO.                                                                              */
/* DEF VAR cTipDto AS CHAR NO-UNDO.                                                                               */
/* DEF VAR f-Factor AS DECI NO-UNDO.                                                                              */
/* DEF VAR f-FleteUnitario AS DECI NO-UNDO.                                                                       */
/* DEF VAR F-DSCTOS AS DECI NO-UNDO.                                                                              */
/* DEF VAR z-Dsctos AS DECI NO-UNDO.                                                                              */
/* DEF VAR x-TipDto AS CHAR NO-UNDO.                                                                              */
/* DEF VAR x-CanPed AS DECI NO-UNDO.                                                                              */
/* DEF VAR s-UndVta AS CHAR NO-UNDO.                                                                              */
/* DEF VAR s-CndVta AS CHAR NO-UNDO.                                                                              */
/* DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.                                                       */
/* DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.                                                       */
/* DEF VAR pCodDiv AS CHAR NO-UNDO.                                                                               */
/* pCodDiv = pcCodDiv.                                                                                            */
/* DEF VAR s-CodMon AS INTE NO-UNDO.                                                                              */
/* s-CodMon = piCodMon.                                                                                           */
/* DEF VAR x-MonVta AS INTE NO-UNDO.       /* Moneda de venta de la lista de precios */                           */
/* DEF VAR s-TpoCmb AS DECI NO-UNDO.                                                                              */
/* DEF VAR x-NroDec AS INTE NO-UNDO.                                                                              */
/* x-NroDec = s-NroDec.                                                                                           */
/*                                                                                                                */
/* DEF VAR x-FlgDtoVol     LIKE GN-DIVI.FlgDtoVol  NO-UNDO.                                                       */
/* DEF VAR x-FlgDtoProm    LIKE GN-DIVI.FlgDtoProm NO-UNDO.                                                       */
/* DEF VAR x-Libre_C01     LIKE GN-DIVI.Libre_C01  NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */     */
/* DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.                                                                     */
/*                                                                                                                */
/* cCodMat  = ENTRY(1,ENTRY(iRegistro,pcReturn),':').                                                             */
/* fPreUni  = DECIMAL(ENTRY(2,ENTRY(iRegistro,pcReturn),':')).                                                    */
/* x-MonVta = INTEGER(ENTRY(3,ENTRY(iRegistro,pcReturn),':')).                                                    */
/* s-TpoCmb = DECIMAL(ENTRY(4,ENTRY(iRegistro,pcReturn),':')).                                                    */
/* s-CndVta = pcFmaPgo.                                                                                           */
/*                                                                                                                */
/* x-FlgDtoVol     = gFlgDtoVol.                                                                                  */
/* x-FlgDtoProm    = gFlgDtoProm.                                                                                 */
/* x-Libre_c01     = gLibre_C01.                                                                                  */
/* x-Ajuste-por-flete = gAjuste-por-flete.                                                                        */
/*                                                                                                                */
/* /* *************************************************************************** */                              */
/* /* Posicionamos registro en ITEM */                                                                            */
/* /* *************************************************************************** */                              */
/* FIND FIRST ITEM WHERE ITEM.codmat = cCodMat EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                                   */
/* IF NOT AVAILABLE ITEM THEN NEXT.                                                                               */
/* FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = cCodMat NO-LOCK.                          */
/*                                                                                                                */
/* ASSIGN                                                                                                         */
/*     F-FACTOR = ITEM.Factor                                                                                     */
/*     x-CanPed = ITEM.CanPed                                                                                     */
/*     s-UndVta = ITEM.UndVta                                                                                     */
/*     f-PreVta = ITEM.PreUni                                                                                     */
/*     f-PreBas = ITEM.PreBas                                                                                     */
/*     f-Dsctos = ITEM.PorDto                                                                                     */
/*     z-Dsctos = ITEM.Por_Dsctos[2]                                                                              */
/*     y-Dsctos = ITEM.Por_Dsctos[3]                                                                              */
/*     x-TipDto = ''.                                                                                             */
/*                                                                                                                */
/* /* Unidad de Venta */                                                                                          */
/* IF TRUE <> (s-UndVta > '') THEN DO:                                                                            */
/*     /*IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.*/                                      */
/*     IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.                                         */
/*     IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndStk.                                         */
/*     IF TRUE <> (s-UndVta > '') THEN DO:                                                                        */
/*         pMensaje = 'Producto: ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.                         */
/*         RETURN "ADM-ERROR".                                                                                    */
/*     END.                                                                                                       */
/* END.                                                                                                           */
/*                                                                                                                */
/* ASSIGN                                                                                                         */
/*     f-Factor = 1.                                                                                              */
/* /* Revisemos el factor de conversión */                                                                        */
/* FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas AND                                                    */
/*     Almtconv.Codalter = s-UndVta NO-LOCK NO-ERROR.                                                             */
/* IF NOT AVAILABLE Almtconv THEN DO:                                                                             */
/*     pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) + */
/*         'Unidad de venta: ' + s-UndVta.                                                                        */
/*     RETURN "ADM-ERROR".                                                                                        */
/* END.                                                                                                           */
/* f-Factor = Almtconv.Equival.                                                                                   */

/* Definimos si es por contrato o no */
CASE TRUE:
    /* CONTRATO: OJO siempre en SOLES */
    WHEN ENTRY(7,ENTRY(iRegistro,pcReturn),':') = "Y" THEN DO:
        ASSIGN
            f-PreVta = fPreUni * f-Factor
            y-DSCTOS = 0
            x-TipDto = "CONTRATO".
        IF piCodMon = 1 THEN DO:
            IF x-MonVta = 1 THEN ASSIGN f-PreVta = f-PreVta.
            ELSE ASSIGN f-PreVta = f-PreVta * s-TPOCMB.
        END.
        IF piCodMon = 2 THEN DO:
            IF x-MonVta = 2 THEN ASSIGN f-PreVta = f-PreVta.
            ELSE ASSIGN f-PreVta = (f-PreVta / s-TPOCMB).
        END.
        ASSIGN
            f-PreBas = f-PreVta.
        /************************************************/
        RUN lib/RedondearMas (F-PREVTA, s-NRODEC, OUTPUT f-PREVTA).
        /************************************************/
    END.
    /* NO CONTRATO */
    OTHERWISE DO:
        /************ Descuento Promocional ************/
        /* RHC 15/07/17 LAS SIGUIENTES REGLAS VIENEN DE EVENTOS ANTERIORES */
        /* Solo afecta a las familias 011 y 013 con excepción de (familia 013 y subfamilia 014) */
        /* *************************************************************************** */
        PROMOCIONAL:    /* RHC 01/10/2020 Y.M. solo para línea 013 */
        DO:
            IF LOOKUP(Almmmatg.CodFam, "013") = 0 THEN LEAVE PROMOCIONAL.
            IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "014" THEN LEAVE PROMOCIONAL.
            ASSIGN                                           
                x-FlgDtoVol = YES                                
                x-FlgDtoProm = NO.
        END.
        PROMOCIONAL:    /* RHC 29/09/2020 Y.M. no va la línea 013 */
        DO:
            IF LOOKUP(Almmmatg.CodFam, "011") = 0 THEN LEAVE PROMOCIONAL.
            ASSIGN                                           
                x-FlgDtoVol = YES                                
                x-FlgDtoProm = NO                                
                x-Libre_C01 = ""           /* ACUMULATIVAS - Daniel Llican, con autorizacion de Mayra Padilla - 08Abr2022 */
                .
        END.
        /* *************************************************************************** */
        /* *************************************************************************** */
        /* RHC 19/02/2015 En caso de Fotocopias (011) se amplia el límite a 60 dias */
        /* *************************************************************************** */
        s-CndVta = pcFmaPgo.
        pDiasDctoVol = gDiasDctoVol.        /* OJO */
        IF Almmmatg.CodFam = "011" THEN pDiasDctoVol = 60.
        IF piCodMon = 2 AND Almmmatg.CodFam = "011" THEN s-CndVta = "000".   /* Contado */
        /* *************************************************************************** */
        /* RHC 22/07/2016  TRANSFERENCIA GRATUITA */
        /* *************************************************************************** */
        IF S-CNDVTA = "899" THEN ASSIGN s-CndVta = "000".

        IF LOOKUP(S-CNDVTA, "899,900") > 0 THEN
            ASSIGN                           
            x-FlgDtoVol = NO
            x-FlgDtoProm = NO                                
            .
        ASSIGN
            F-PreVta = fPreUni * f-Factor   /* OJO */
            F-PreBas = f-PreVta.            /* Valor por Defecto */

        /* ****************************************************************************************** */
        /* PROCEDIMIENTO NORMAL */
        /* ****************************************************************************************** */
        /* Rutina única */
        /* ****************************************************************************************** */
        IF pcTpoPed = "M" THEN ASSIGN x-FlgDtoVol = NO x-FlgDtoProm = NO.
        CASE gn-divi.VentaMayorista:
            WHEN 1 THEN DO:
                RUN Precio-Empresa (INPUT s-undvta,
                                    INPUT f-Factor,
                                    INPUT s-cndvta,
                                    INPUT pCodDiv,
                                    INPUT x-canped,
                                    INPUT x-flgdtovol,
                                    INPUT x-flgdtoprom,
                                    OUTPUT f-dsctos,
                                    OUTPUT y-dsctos,
                                    OUTPUT z-dsctos,
                                    OUTPUT x-tipdto,
                                    INPUT x-libre_c01,
                                    INPUT-OUTPUT f-prevta,
                                    INPUT s-codmon,
                                    INPUT x-monvta,
                                    INPUT s-tpocmb,
                                    INPUT-OUTPUT f-prebas,
                                    INPUT x-nrodec).
            END.
            WHEN 2 THEN DO:
                RUN Precio-Division (INPUT s-undvta,
                                    INPUT f-Factor,
                                    INPUT s-cndvta,
                                    INPUT pCodDiv,
                                    INPUT x-canped,
                                    INPUT x-flgdtovol,
                                    INPUT x-flgdtoprom,
                                    OUTPUT f-dsctos,
                                    OUTPUT y-dsctos,
                                    OUTPUT z-dsctos,
                                    OUTPUT x-tipdto,
                                    INPUT x-libre_c01,
                                    INPUT-OUTPUT f-prevta,
                                    INPUT s-codmon,
                                    INPUT x-monvta,
                                    INPUT s-tpocmb,
                                    INPUT-OUTPUT f-prebas,
                                    INPUT x-nrodec).
            END.
        END CASE.
        /* *************************************************************************** */
        /* PRECIO CONTRATOS NO AFECTO A FLETE */
        /* *************************************************************************** */
        /* Determinamos el Flete Unitario */
        /* *************************************************************************** */
        /* 1ro. Factor Harold Segura */
        /* *************************************************************************** */
        RUN vtagn/flete-unitario-general-v01.p (cCodMat,
                                                pCodDiv,
                                                S-CODMON,
                                                f-Factor,
                                                OUTPUT f-FleteUnitario).
        /* *************************************************************************** */
        /* 2do. Factor Karin Rodhenberg */
        /* *************************************************************************** */
        RUN gn/factor-porcentual-flete-v3.p (INPUT pcoddiv, 
                                             INPUT cCodMat,
                                             INPUT-OUTPUT f-FleteUnitario, 
                                             INPUT pcTpoPed, 
                                             INPUT f-factor, 
                                             INPUT s-CodMon,
                                             INPUT f-PreVta).
    END.
END CASE.
/* TODAS LAS LISTAS AFECTAS A RECARGO */
/* ***************************************************************************************** */
/* 30/10/2023: Incremento de precio por RECARGO (papel fill) C.Camus */
/* ***************************************************************************************** */
RUN Recargo (INPUT cCodMat,
             INPUT s-CodMon,
             INPUT s-TpoCmb,
             INPUT-OUTPUT f-PreBas,
             INPUT-OUTPUT f-PreVta).

/* ***************************************************************************************** */
/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
/* ***************************************************************************************** */
ASSIGN z-Dsctos = 0.

/* ***************************************************************************************** */
/* OJO: Control de Precio Base */
F-PREBAS = F-PREVTA.
/* *************************************************************************** */

ASSIGN 
    ITEM.Factor = f-Factor
    ITEM.UndVta = s-UndVta
    ITEM.PreUni = F-PREVTA
    ITEM.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
    ITEM.PreBas = F-PreBas 
    ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
    ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
    ITEM.PorDto2 = 0            /* el precio unitario */
    ITEM.Por_Dsctos[2] = z-Dsctos
    ITEM.Por_Dsctos[3] = Y-DSCTOS 
    ITEM.AftIgv = Almmmatg.AftIgv
    ITEM.AftIsc = Almmmatg.AftIsc
    ITEM.ImpIsc = 0
    ITEM.ImpIgv = 0
    ITEM.Libre_c04 = x-TipDto.

/* ***************************************************************** */
{vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
/* ***************************************************************** */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Dispara-API) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Dispara-API Procedure 
PROCEDURE Dispara-API :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pcCodCli  AS CHAR.
DEF INPUT PARAMETER pcCodDiv  AS CHAR.
DEF INPUT PARAMETER pcCodMat  AS LONGCHAR.
DEF INPUT PARAMETER pcClfCli  AS LONGCHAR.
DEF INPUT PARAMETER pcFmaPgo  AS LONGCHAR.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR     NO-UNDO.

/* Formato de pcReturn
000752:13.3572:2:3.55:002:C:N
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
*/

DEFINE VAR hProc AS HANDLE NO-UNDO.

/* Inicialización de salidas */
ASSIGN
    pcReturn = ""
    pMensaje = "".

/* ------------------------------------------------------------------------- */
/* 1. Instanciación segura de la librería                                   */
/* ------------------------------------------------------------------------- */
RUN web/web-library.p PERSISTENT SET hProc NO-ERROR.

IF ERROR-STATUS:ERROR OR NOT VALID-HANDLE(hProc) THEN DO:
    pMensaje = "ERROR: No se pudo instanciar la librería web/web-library.p".
    RETURN 'ADM-ERROR'.
END.

/* ------------------------------------------------------------------------- */
/* 2. Ejecución del procedimiento manager                                   */
/* ------------------------------------------------------------------------- */
RUN web_api_unit_price_manager IN hProc (INPUT pcCodCli,
                                         INPUT pcCodDiv,
                                         INPUT pcCodMat,
                                         INPUT pcClfCli,
                                         INPUT pcFmaPgo,
                                         OUTPUT pcReturn,
                                         OUTPUT pMensaje) NO-ERROR.

/* ------------------------------------------------------------------------- */
/* 3. Limpieza del Handle (Siempre validar antes de eliminar)                */
/* ------------------------------------------------------------------------- */
IF VALID-HANDLE(hProc) THEN DELETE PROCEDURE hProc.

/* ------------------------------------------------------------------------- */
/* 4. Validación de Errores de Ejecución y Contenido                         */
/* ------------------------------------------------------------------------- */

/* Error del sistema en la ejecución del RUN */
IF ERROR-STATUS:ERROR THEN DO:
    IF pMensaje = "" OR pMensaje = ? THEN
        pMensaje = "ERROR: Falló la ejecución de web_api_unit_price_manager.".
    RETURN 'ADM-ERROR'.
END.

/* Error retornado en el parámetro pMensaje */
IF pMensaje <> "" AND pMensaje <> ? THEN DO:
    RETURN 'ADM-ERROR'.
END.

/* Error retornado por RETURN-VALUE */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN DO: */
/*     RETURN 'ADM-ERROR'.                */
/* END.                                   */

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Dispara-API_old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Dispara-API_old Procedure 
PROCEDURE Dispara-API_old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER pcCodCli AS CHAR.
DEF INPUT PARAMETER pcCodDiv AS CHAR.
DEF INPUT PARAMETER pcCodMat AS LONGCHAR.
DEF INPUT PARAMETER pcClfCli AS LONGCHAR.
DEF INPUT PARAMETER pcFmaPgo AS LONGCHAR.
DEF OUTPUT PARAMETER pcReturn AS LONGCHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* Formato de pcReturn
000752:13.3572:2:3.55:002:C:N
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
*/

/* API */
DEFINE VAR hProc AS HANDLE NO-UNDO.
RUN web/web-library PERSISTENT SET hProc.
RUN web_api_unit_price_manager IN hProc (INPUT pcCodCli,
                                         INPUT pcCodDiv,
                                         INPUT pcCodMat,
                                         INPUT pcClfCli,
                                         INPUT pcFmaPgo,
                                         OUTPUT pcReturn,
                                         OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Contrato-Marco) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Contrato-Marco Procedure 
PROCEDURE Precio-Contrato-Marco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION:
    EMPTY TEMP-TABLE ITEM_MARCO.
    EMPTY TEMP-TABLE ITEM_FINAL.
    FOR EACH ITEM:
        CREATE ITEM_MARCO.
        BUFFER-COPY ITEM TO ITEM_MARCO.
    END.
END.

/* ************************************************************************** */
/* 1.   PROCESAMOS PRIMERO LOS PRECIOS POR CONTRATO MARCO */
/* ************************************************************************** */
EMPTY TEMP-TABLE ITEM.
FOR EACH ITEM_MARCO, FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat = ITEM_MARCO.codmat NO-LOCK:
    FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatp THEN DO:
        CREATE ITEM.
        BUFFER-COPY ITEM_MARCO TO ITEM.
    END.
END.
DEF VAR F-PREBAS AS DEC DECIMALS 4.
DEF VAR F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF VAR F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF VAR Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF VAR Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF VAR X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF VAR S-UNDVTA AS CHAR.
DEF VAR x-FlgDtoClfCli AS LOG NO-UNDO.
DEF VAR x-FlgDtoCndVta AS LOG NO-UNDO.
DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.     /* Dcto Excluyentes, acumulados o el mejor */
DEF VAR f-Factor AS DEC.       /* Default 1 */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR S-CNDVTA AS CHAR.       /* Condicion de venta */     
DEF VAR x-DctoPromocional AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR x-DctoxVolumen    AS DECIMAL DECIMALS 4 NO-UNDO.
DEF VAR pCodDiv AS CHAR.    /* Lista de Precios */
DEF VAR X-CANPED AS DEC.
DEF VAR S-CODMAT AS CHAR.
DEF VAR S-CODCLI AS CHAR.
DEF VAR s-TpoPed AS CHAR.   /* Tipo de Pedido */
DEF VAR S-CODMON AS INT.
DEF VAR x-NroDec AS INT.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
/*DEF VAR s-PorIgv AS DECI NO-UNDO.*/
DEF VAR x-MonVta AS INTE NO-UNDO.

ASSIGN
    pCodDiv = pcCodDiv
    s-CodCli = pcCodCli
    s-TpoPed = pcTpoPed
    s-CodMon = piCodMon
    x-NroDec = s-NroDec
    x-MonVta = 1        /* Siempre en Soles */
    .

FOR EACH ITEM, 
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat NO-LOCK,
    FIRST Almmmatp OF Almmmatg NO-LOCK:
    ASSIGN
        s-UndVta = ITEM.UndVta
        f-Factor = ITEM.Factor.
    IF TRUE <> (s-UndVta > '') THEN DO:
        /*IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.*/
        IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
        IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndStk.
        IF TRUE <> (s-UndVta > '') THEN DO:
            pMensaje = 'Producto: ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.
            NEXT.
        END.
    END.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
        AND Almtconv.Codalter = s-undvta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        pMensaje = pMensaje + ( IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(13) ) +
            'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
            '   Unidad Stock: ' + Almmmatg.UndBas + CHR(10) +
            'Unidad de Venta: ' + s-UndVta.
        NEXT.
    END.
    F-FACTOR = Almtconv.Equival.

    /* PRECIO BASE Y UNIDAD DE VENTA */
    ASSIGN
        F-PreVta = Almmmatp.PreOfi * f-Factor       /* OJO */
        pDiasDctoPro = 999999
        x-FlgDtoClfCli = NO
        x-FlgDtoCndVta = NO
        x-FlgDtoProm = YES
        x-FlgDtoVol = YES
        x-Libre_C01 = ""    /* EXCLUYENTES */
        .
    
    {pri/unit-price-credit-sale.i ~
        &Tabla=Almmmatp ~
        /*&PreVta=Almmmatp.PreOfi ~*/
        &Promocional="~
            DO J = 1 TO 10:~
                IF Almmmatp.PromDivi[J] = pCodDiv~
                    AND TODAY >= Almmmatp.PromFchD[J]~
                    AND TODAY <= Almmmatp.PromFchH[J]~
                    AND Almmmatp.PromDto[J] > 0 THEN DO:~
                    x-DctoPromocional = Almmmatp.PromDto[J].~
                END.~
            END."}
    
    /* DESCUENTOS ADICIONALES POR DIVISION */
    z-Dsctos = 0.
    /* ***************************************************************************************** */
    /* OJO: Control de Precio Base */
    F-PREBAS = F-PREVTA.
    /* *************************************************************************** */
    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.UndVta = s-UndVta
        ITEM.PreUni = F-PREVTA
        ITEM.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0            /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0
        ITEM.Libre_c04 = x-TipDto.
   /* ***************************************************************** */
   {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
   /* ***************************************************************** */

END.
/* ************************************************************************** */
/* 2.   PROCESAMOS AHORA PRECIOS POR TIENDA */
/* ************************************************************************** */
FOR EACH ITEM:
    CREATE ITEM_FINAL.
    BUFFER-COPY ITEM TO ITEM_FINAL.
    DELETE ITEM.
END.
FOR EACH ITEM_MARCO, FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia 
        AND Almmmatg.codmat = ITEM_MARCO.codmat NO-LOCK:
    FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almmmatp THEN DO:
        CREATE ITEM.
        BUFFER-COPY ITEM_MARCO TO ITEM.
    END.
END.

RUN Precio-Tiendas.
IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".

/* ************************************************************************** */
/* 3.   UNIMOS RESULTADOS */
/* ************************************************************************** */
FOR EACH ITEM_FINAL:
    CREATE ITEM.
    BUFFER-COPY ITEM_FINAL TO ITEM.
END.

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

DEF INPUT PARAMETER s-undvta AS CHAR.
DEF INPUT PARAMETER f-Factor AS DECI.
DEF INPUT PARAMETER s-cndvta AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER x-CanPed AS DECI.
DEF INPUT PARAMETER x-FlgDtoVol AS LOG.
DEF INPUT PARAMETER x-FlgDtoProm AS LOG.
DEF OUTPUT PARAMETER F-DSCTOS AS DECI.
DEF OUTPUT PARAMETER Y-DSCTOS AS DECI.
DEF OUTPUT PARAMETER Z-DSCTOS AS DECI.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.
DEF INPUT PARAMETER x-Libre_C01 AS CHAR.
DEF INPUT-OUTPUT PARAMETER F-PREVTA AS DECI.
DEF INPUT PARAMETER s-CodMon AS INTE.
DEF INPUT PARAMETER x-MonVta AS INTE.
DEF INPUT PARAMETER s-TpoCmb AS DECI.
DEF INPUT-OUTPUT PARAMETER F-PREBAS AS DECI.
DEF INPUT PARAMETER X-NRODEC AS INTE.

DEF VAR x-DctoPromocional AS DECI NO-UNDO.
DEF VAR x-DctoxVolumen AS DECI NO-UNDO.

FIND VtaListaMay WHERE VtaListaMay.codcia = s-codcia AND
    VtaListaMay.coddiv = pCodDiv AND
    VtaListamay.codmat = Almmmatg.CodMat
    NO-LOCK NO-ERROR.

    /*{pri/PrecioVentaMayorCreditoFlash.i ~*/
    {pri/unit-price-credit-sale.i ~
        &Tabla=VtaListaMay ~
        /*&PreVta=F-PREVTA ~*/
        &Promocional="~
        /* Tomamos el mayor descuento */ ~
        DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
        x-Old-Descuento = 0. ~
        FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
            VtaDctoProm.CodDiv = pCodDiv AND ~
            VtaDctoProm.CodMat = Almmmatg.CodMat AND ~
            VtaDctoProm.FlgEst = 'A' AND ~
            (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
            /* Solo en caso de EVENTOS existe el VIP, MR */ ~
            x-DctoPromocional = VtaDctoProm.Descuento. ~
            x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
            x-Old-Descuento = x-DctoPromocional. ~
        END. ~
        " }

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

DEF INPUT PARAMETER s-undvta AS CHAR.
DEF INPUT PARAMETER f-Factor AS DECI.
DEF INPUT PARAMETER s-cndvta AS CHAR.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER x-CanPed AS DECI.
DEF INPUT PARAMETER x-FlgDtoVol AS LOG.
DEF INPUT PARAMETER x-FlgDtoProm AS LOG.
DEF OUTPUT PARAMETER F-DSCTOS AS DECI.
DEF OUTPUT PARAMETER Y-DSCTOS AS DECI.
DEF OUTPUT PARAMETER Z-DSCTOS AS DECI.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.
DEF INPUT PARAMETER x-Libre_C01 AS CHAR.
DEF INPUT-OUTPUT PARAMETER F-PREVTA AS DECI.
DEF INPUT PARAMETER s-CodMon AS INTE.
DEF INPUT PARAMETER x-MonVta AS INTE.
DEF INPUT PARAMETER s-TpoCmb AS DECI.
DEF INPUT-OUTPUT PARAMETER F-PREBAS AS DECI.
DEF INPUT PARAMETER X-NRODEC AS INTE.

DEF VAR x-DctoPromocional AS DECI NO-UNDO.
DEF VAR x-DctoxVolumen AS DECI NO-UNDO.

    /*{pri/PrecioVentaMayorCreditoFlash.i ~*/
    {pri/unit-price-credit-sale.i ~
        &Tabla=Almmmatg ~
        /*&PreVta=F-PREVTA ~*/
        &Promocional="~
        /* Tomamos el mayor descuento */ ~
        DEF VAR x-Old-Descuento AS DEC NO-UNDO. ~
        x-Old-Descuento = 0. ~
        FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND ~
            VtaDctoProm.CodDiv = pCodDiv AND ~
            VtaDctoProm.CodMat = Almmmatg.CodMat AND ~
            VtaDctoProm.FlgEst = 'A' AND ~
            (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): ~
            /* Solo en caso de EVENTOS existe el VIP, MR */ ~
            x-DctoPromocional = VtaDctoProm.Descuento. ~
            x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). ~
            x-Old-Descuento = x-DctoPromocional. ~
        END. ~
        " }

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Expolibreria) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Expolibreria Procedure 
PROCEDURE Precio-Expolibreria :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Solo pasan por aquí si la lista de precios está definid POR DIVISION */
IF NOT (GN-DIVI.VentaMayorista = 2) THEN DO:
    pMensaje = 'La lista de precios NO es una LISTA POR DIVISION: ' + pcCodDiv.
    RETURN "ADM-ERROR".
END.

DEF VAR pcListaArticulos        AS LONGCHAR NO-UNDO.
DEF VAR pcListaClasificacion    AS LONGCHAR NO-UNDO.
DEF VAR pcListaCondiciones      AS LONGCHAR NO-UNDO.

/* ******************************************************************************************** */
/* 1.- Cargamos los parámetros para el API */
/* ******************************************************************************************** */
FOR EACH ITEM NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat NO-LOCK:
    /* *************************************************************************** */
    /* CLASIFICACION DEL CLIENTE */
    /* *************************************************************************** */
    ASSIGN
        x-ClfCli  = "C"         /* Valores por defecto */
        x-ClfCli2 = "C".
    IF AVAIL gn-clie AND gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
    IF AVAIL gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
    /* *************************************************************************** */
    /* 1/9/2025: César Camus, tabla de excepciones productos propios */
    /* *************************************************************************** */
    IF Almmmatg.CHR__02 = "P" THEN DO:
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia 
            AND VtaTabla.Tabla = "CUSTOMER_CLFCLI_CR" 
            AND VtaTabla.Llave_c1 = pcCodCli
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Llave_c3 > "" THEN x-ClfCli  = VtaTabla.Llave_c3.
    END.
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* Parámetros BASE para el artículo */
    /* *************************************************************************** */
    /* *************************************************************************** */
    cClfCli = (IF Almmmatg.CHR__02 = "P" THEN x-ClfCli ELSE x-ClfCli2).
    cFmaPgo = pcFmaPgo.                                                           
    /* *************************************************************************** */
    /* 1/9/2025: César Camus, tabla de excepciones productos propios */
    /* *************************************************************************** */
    IF Almmmatg.CHR__02 = "P" THEN DO:
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia 
            AND VtaTabla.Tabla = "CUSTOMER_CLFCLI_CR" 
            AND VtaTabla.Llave_c1 = pcCodCli
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Llave_c3 > "" THEN cClfCli  = VtaTabla.Llave_c3.
    END.
    /* *************************************************************************** */
    pcListaArticulos = pcListaArticulos + 
        (IF TRUE <> (pcListaArticulos > '') THEN '' ELSE ',') +
        TRIM(ITEM.CodMat).
    pcListaClasificacion = pcListaClasificacion + 
        (IF TRUE <> (pcListaClasificacion > '') THEN '' ELSE ',') +
        TRIM(cClfCli).
    pcListaCondiciones = pcListaCondiciones + 
        (IF TRUE <> (pcListaCondiciones > '') THEN '' ELSE ',') +
        TRIM(cFmaPgo).

END.
/* ******************************************************************************************** */
/* 2.- Solicitamos los artículos y sus precios al API */
/* ******************************************************************************************** */
DEF VAR pcReturn AS LONGCHAR NO-UNDO.
RUN Dispara-API (INPUT pcCodCli,
                 INPUT pcCodDiv,
                 INPUT pcListaArticulos,
                 INPUT pcListaClasificacion,
                 INPUT pcListaCondiciones,
                 OUTPUT pcReturn,
                 OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
/* Formato de pcReturn
000752:13.3572:2:3.55:002:C:N
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
*/
/* ******************************************************************************************** */
/* 3.- Actualizamos los precios en ITEM */
/* ******************************************************************************************** */
DEF VAR iRegistro AS INTE NO-UNDO.

DO iRegistro = 1 TO NUM-ENTRIES(pcReturn):
    RUN Calculo-por-item-evento (INPUT pcReturn, INPUT iRegistro, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
        pMensaje = "".
    END.
    /*IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.*/
END.
FOR EACH ITEM WHERE ITEM.preuni <= 0:
    DELETE ITEM.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Remate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Remate Procedure 
PROCEDURE Precio-Remate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR F-FACTOR AS DECI NO-UNDO.
DEF VAR s-codmat AS CHAR NO-UNDO.
DEF VAR s-CodMon AS DECI NO-UNDO.
DEF VAR F-PREBAS AS DEC DECIMALS 4.
DEF VAR F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF VAR X-NRODEC AS INTE NO-UNDO.
DEF VAR f-FleteUnitario AS DECI NO-UNDO.
DEF VAR F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF VAR Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF VAR Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF VAR X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 

ASSIGN
    s-CodMon = piCodMon
    X-NRODEC = s-NroDec
    .

FOR EACH ITEM, FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat NO-LOCK:
    ASSIGN
        x-ClfCli  = "C"         /* Valores por defecto */
        x-ClfCli2 = "C".
    IF AVAIL gn-clie AND gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
    IF AVAIL gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
    /* *************************************************************************** */
    /* 1/9/2025: César Camus, tabla de excepciones productos propios */
    /* *************************************************************************** */
    IF Almmmatg.CHR__02 = "P" THEN DO:
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia 
            AND VtaTabla.Tabla = "CUSTOMER_CLFCLI_CR" 
            AND VtaTabla.Llave_c1 = pcCodCli
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Llave_c3 > "" THEN x-ClfCli  = VtaTabla.Llave_c3.
    END.
    s-UndVta = ITEM.UndVta.
    F-FACTOR = ITEM.factor.
    s-codmat = ITEM.codmat.
    IF TRUE <> (s-UndVta > '') THEN DO:
        /*IF Almmmatg.Chr__01 > '' THEN ASSIGN s-UndVta = Almmmatg.Chr__01.*/
        IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndBas.
        IF TRUE <> (s-UndVta > '') THEN ASSIGN s-UndVta = Almmmatg.UndStk.
        IF TRUE <> (s-UndVta > '') THEN DO:
            pMensaje = 'Producto: ' + Almmmatg.CodMat + ' NO definida la unidad de venta'.
            NEXT.
        END.
    END.
    FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas
        AND Almtconv.Codalter = s-undvta
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almtconv THEN DO:
        pMensaje = pMensaje + ( IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(13) ) +
            'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
            '   Unidad Stock: ' + Almmmatg.UndBas + CHR(10) +
            'Unidad de Venta: ' + s-UndVta.
        NEXT.
    END.
    F-FACTOR = Almtconv.Equival.

    FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'REMATES'
        AND Vtatabla.llave_c1 = s-codmat
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE VtaTabla THEN DO:
        pMensaje = pMensaje + ( IF TRUE <> (pMensaje > '') THEN '' ELSE CHR(13) ) +
            "Producto" + Almmmatg.codmat + " en REMATE NO tiene precio de venta".
        NEXT.
    END.
    IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = VtaTabla.Valor[1].
    ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * Almmmatg.TpoCmb, 6 ).
    ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] / Almmmatg.TpoCmb, 6 ).

    ASSIGN
        F-PREVTA = F-PREBAS * f-Factor.     /* OJO */
    RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

    /* DESCUENTOS ADICIONALES POR DIVISION */
    z-Dsctos = 0.
    /* ***************************************************************************************** */
    /* OJO: Control de Precio Base */
    F-PREBAS = F-PREVTA.
    /* *************************************************************************** */

    ASSIGN 
        ITEM.Factor = f-Factor
        ITEM.UndVta = s-UndVta
        ITEM.PreUni = F-PREVTA
        ITEM.Libre_d02 = f-FleteUnitario    /* Flete Unitario */
        ITEM.PreBas = F-PreBas 
        ITEM.PreVta[1] = F-PreVta   /* CONTROL DE PRECIO DE LISTA */
        ITEM.PorDto = F-DSCTOS      /* Ambos descuentos afectan */
        ITEM.PorDto2 = 0            /* el precio unitario */
        ITEM.Por_Dsctos[2] = z-Dsctos
        ITEM.Por_Dsctos[3] = Y-DSCTOS 
        ITEM.AftIgv = Almmmatg.AftIgv
        ITEM.AftIsc = Almmmatg.AftIsc
        ITEM.ImpIsc = 0
        ITEM.ImpIgv = 0
        ITEM.Libre_c04 = x-TipDto.
   /* ***************************************************************** */
   {vtagn/CalculoDetalleMayorCredito.i &Tabla="ITEM" }
   /* ***************************************************************** */
END.

FOR EACH ITEM WHERE ITEM.preuni <= 0:
    DELETE ITEM.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Tiendas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Tiendas Procedure 
PROCEDURE Precio-Tiendas PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR pcListaArticulos AS LONGCHAR NO-UNDO.
DEF VAR pcListaClasificacion AS LONGCHAR NO-UNDO.
DEF VAR pcListaCondiciones AS LONGCHAR NO-UNDO.

/* ******************************************************************************************** */
/* 1.- Cargamos los parámetros para el API */
/* ******************************************************************************************** */
FOR EACH ITEM NO-LOCK,
    FIRST Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat NO-LOCK:
    ASSIGN
        x-ClfCli  = "C"         /* Valores por defecto */
        x-ClfCli2 = "C".
    IF AVAIL gn-clie AND gn-clie.clfcli  > '' THEN x-ClfCli  = gn-clie.clfcli.
    IF AVAIL gn-clie AND gn-clie.clfcli2 > '' THEN x-ClfCli2 = gn-clie.clfcli2.
    /* *************************************************************************** */
    /* 1/9/2025: César Camus, tabla de excepciones productos propios */
    /* *************************************************************************** */
    IF Almmmatg.CHR__02 = "P" THEN DO:
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia 
            AND VtaTabla.Tabla = "CUSTOMER_CLFCLI_CR" 
            AND VtaTabla.Llave_c1 = pcCodCli
            AND VtaTabla.Llave_c2 = Almmmatg.codfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla AND VtaTabla.Llave_c3 > "" THEN x-ClfCli  = VtaTabla.Llave_c3.
    END.

    /* *************************************************************************** */
    /************ Descuento Promocional ************/
    /* RHC 15/07/17 LAS SIGUIENTES REGLAS VIENEN DE EVENTOS ANTERIORES */
    /* Solo afecta a las familias 011 y 013 con excepción de (familia 013 y subfamilia 014) */
    /* *************************************************************************** */
    PROMOCIONAL:    /* RHC 01/10/2020 Y.M. solo para línea 013 */
    DO:
        IF LOOKUP(Almmmatg.CodFam, "013") = 0 THEN LEAVE PROMOCIONAL.
        IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam = "014" THEN LEAVE PROMOCIONAL.
        ASSIGN 
            x-ClfCli = "C" 
            x-ClfCli2 = "C". 
    END.
    PROMOCIONAL:    /* RHC 29/09/2020 Y.M. no va la línea 013 */
    DO:
        IF LOOKUP(Almmmatg.CodFam, "011") = 0 THEN LEAVE PROMOCIONAL.
        ASSIGN 
            x-ClfCli = "C" 
            x-ClfCli2 = "C". 
    END.
    /* *************************************************************************** */
    cFmaPgo = pcFmaPgo.     /* Valor por defecto */
    /* 19/02/2015 En caso de Fotocopias (011) */
    IF piCodMon = 2 AND Almmmatg.CodFam = "011" THEN cFmaPgo = "000".   /* Contado */
    /* *************************************************************************** */
    /* 22/07/2016  TRANSFERENCIA GRATUITA */
    /* *************************************************************************** */
    IF cFmaPgo = "899" THEN cFmaPgo = "000".
    IF LOOKUP(STRING(cFmaPgo), "899,900") > 0 THEN         
        ASSIGN 
        x-ClfCli = "C" 
        x-ClfCli2 = "C". 
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* *************************************************************************** */
    /* Parámetros BASE para el artículo */
    /* *************************************************************************** */
    cClfCli = (IF Almmmatg.CHR__02 = "P" THEN x-ClfCli ELSE x-ClfCli2).
    /* *************************************************************************** */
    pcListaArticulos = pcListaArticulos + 
        (IF TRUE <> (pcListaArticulos > '') THEN '' ELSE ',') +
        TRIM(ITEM.CodMat).
    pcListaClasificacion = pcListaClasificacion + 
        (IF TRUE <> (pcListaClasificacion > '') THEN '' ELSE ',') +
        TRIM(cClfCli).
    pcListaCondiciones = pcListaCondiciones + 
        (IF TRUE <> (pcListaCondiciones > '') THEN '' ELSE ',') +
        TRIM(cFmaPgo).
END.
/* ******************************************************************************************** */
/* 2.- Solicitamos los artículos y sus precios al API */
/* ******************************************************************************************** */
DEF VAR pcReturn AS LONGCHAR NO-UNDO.
RUN Dispara-API (INPUT pcCodCli,
                 INPUT pcCodDiv,
                 INPUT pcListaArticulos,
                 INPUT pcListaClasificacion,
                 INPUT pcListaCondiciones,
                 OUTPUT pcReturn,
                 OUTPUT pMensaje).
IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.

/* Formato de pcReturn
000752:13.3572:2:3.55:002:C:N
<CodMat>:<PreUni>:<CodMon>:<TpoCmb>:<FmaPgo>:<ClfCli>:<Contrato>
*/
/* ******************************************************************************************** */
/* 3.- Actualizamos los precios en ITEM */
/* ******************************************************************************************** */
DEF VAR iRegistro AS INTE NO-UNDO.

DO iRegistro = 1 TO NUM-ENTRIES(pcReturn):
    RUN Calculo-por-item-tienda (INPUT pcReturn, INPUT iRegistro, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        MESSAGE pMensaje VIEW-AS ALERT-BOX WARNING.
        pMensaje = "".
    END.
    /*IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.*/
END.
FOR EACH ITEM WHERE ITEM.preuni <= 0:
    DELETE ITEM.
END.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Recargo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Recargo Procedure 
PROCEDURE Recargo PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER s-Codmat AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INTE.
DEF INPUT PARAMETER S-TPOCMB AS DECI.
DEF INPUT-OUTPUT PARAMETER f-PreBas AS DECI.
DEF INPUT-OUTPUT PARAMETER f-PreVta AS DECI.

DEF VAR x-Recargo AS DECI NO-UNDO.

FIND FacTabla WHERE FacTabla.CodCia = s-codcia AND 
    FacTabla.Tabla = "RECARGO_CREDITOS" AND
    FacTabla.Codigo = pcCodDiv NO-LOCK NO-ERROR.
IF AVAILABLE FacTabla THEN DO:
    x-Recargo = FacTabla.Valor[1].
    /* Buscamos excepciones */
    FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN 
    EXCEPCION:
    DO:
        /* Excepción por SKU */
        FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = FacTabla.codcia AND
            VtaDTabla.Tabla = FacTabla.tabla AND
            VtaDTabla.Llave = FacTabla.Codigo AND
            VtaDTabla.Tipo = "SKU" AND
            VtaDTabla.LlaveDetalle = Almmmatg.codmat
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDTabla THEN DO:
            x-Recargo = VtaDTabla.Libre_d01.
            LEAVE EXCEPCION.
        END.
        /* Excepción por LINEA */
        FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = FacTabla.codcia AND
            VtaDTabla.Tabla = FacTabla.tabla AND
            VtaDTabla.Llave = FacTabla.Codigo AND
            VtaDTabla.Tipo = "LINEA" AND
            VtaDTabla.LlaveDetalle = Almmmatg.codfam AND
            VtaDTabla.Libre_c01 = Almmmatg.subfam
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaDTabla THEN DO:
            x-Recargo = VtaDTabla.Libre_d01.
            LEAVE EXCEPCION.
        END.
        ELSE DO:
            FIND FIRST VtaDTabla WHERE VtaDTabla.CodCia = FacTabla.codcia AND
                VtaDTabla.Tabla = FacTabla.tabla AND
                VtaDTabla.Llave = FacTabla.Codigo AND
                VtaDTabla.Tipo = "LINEA" AND
                VtaDTabla.LlaveDetalle = Almmmatg.codfam AND
                TRUE <> (VtaDTabla.Libre_c01 > '') NO-LOCK NO-ERROR.
            IF AVAILABLE VtaDTabla THEN DO:
                x-Recargo = VtaDTabla.Libre_d01.
                LEAVE EXCEPCION.
            END.
        END.
    END.    /* EXCEPCION */
    IF S-CODMON = 2 THEN ASSIGN x-Recargo = (x-Recargo / S-TPOCMB) /** F-FACTOR*/.
    ASSIGN
        f-PreBas = f-PreBas + x-Recargo
        f-PreVta = f-PreVta + x-Recargo.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

