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

DEF INPUT PARAMETER s-TpoPed AS CHAR.
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.

DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.

DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.

DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.

DEF INPUT PARAMETER pError AS LOG.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* VARIABLES LOCALES */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEF VAR MaxCat AS DEC NO-UNDO.
DEF VAR MaxVta AS DEC NO-UNDO.
DEF VAR x-ClfCli  AS CHAR NO-UNDO.      /* Clasificacion para productos propios */
DEF VAR x-ClfCli2 AS CHAR NO-UNDO.      /* Clasificacion para productos de terceros */
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.

/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.

/* CONTROL POR DIVISION */

DEF VAR x-FlgDtoVol LIKE GN-DIVI.FlgDtoVol NO-UNDO.
DEF VAR x-FlgDtoProm LIKE GN-DIVI.FlgDtoProm NO-UNDO.
DEF VAR x-FlgDtoClfCli LIKE GN-DIVI.FlgDtoClfCli NO-UNDO.
DEF VAR x-FlgDtoCndVta LIKE GN-DIVI.FlgDtoCndVta NO-UNDO.
DEF VAR x-Libre_C01 LIKE GN-DIVI.Libre_C01 NO-UNDO.

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
         HEIGHT             = 10.27
         WIDTH              = 56.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' s-CodMat 'NO registrado en el catálogo general' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PreBas = Almmmatg.PreOfi.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.
ASSIGN
    x-FlgDtoVol = GN-DIVI.FlgDtoVol
    x-FlgDtoProm = GN-DIVI.FlgDtoProm
    x-FlgDtoClfCli = GN-DIVI.FlgDtoClfCli
    x-FlgDtoCndVta = GN-DIVI.FlgDtoCndVta
    x-Libre_C01 = GN-DIVI.Libre_C01.

/* *********************************************** */
/* PRECIOS ESPECIALES POR CONTRATO MARCO Y REMATES */
/* *********************************************** */
CASE s-TpoPed:
    WHEN "M" THEN DO:       /* CASO ESPECIAL -> Ventas CONTRATO MARCO */
        RUN Precio-Contrato-Marco.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        RETURN 'OK'.
    END.
    WHEN "R" THEN DO:       /* CASO ESPECIAL -> REMATES */
        RUN Precio-Remate.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
        RETURN 'OK'.
    END.
END CASE.
/* *********************************************** */
/* RHC 30/07/213 PARCHAZO PARA COMERCIAL LI */
/* Va a simular una venta de Provincias */
IF s-TpoPed = "S" /* CANAL MODERNO */ AND s-CodCli = '20101164901' THEN DO:
    ASSIGN s-CodDiv = '00018'.
    /* CONFIGURACIONES DE LA DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.
    ASSIGN
        x-FlgDtoVol = GN-DIVI.FlgDtoVol
        x-FlgDtoProm = GN-DIVI.FlgDtoProm
        x-FlgDtoClfCli = GN-DIVI.FlgDtoClfCli
        x-FlgDtoCndVta = GN-DIVI.FlgDtoCndVta
        x-Libre_C01 = GN-DIVI.Libre_C01.
END.
/* **************************************************************************** */
/* LISTAS ESPECIALES PRODUCTOS DE TERCEROS  PARA LA DIVISION 00018 - PROVINCIAS */
/* **************************************************************************** */
IF s-CodDiv = '00018' THEN s-CndVta = '000'.    /* OJO <<<< TEMPORALMENTE 11/04/2013 */
IF s-CodDiv = "00018" AND GN-DIVI.Libre_L01 = YES THEN DO:
    RUN Precio-Provincias.
    IF RETURN-VALUE = "OK" THEN RETURN.
    /* SI NO HAY PRECIOS CONTINUA EL CICLO NORMAL */
    IF LOOKUP(s-CndVta, '000,408') > 0 THEN ASSIGN x-FlgDtoVol = NO x-FlgDtoProm = NO.
END.

/* ************************************** */
/* DEFINIMOS LA CLASIFICACION DEL CLIENTE */
/* ************************************** */
FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
    AND gn-clie.CodCli = S-CODCLI 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie AND pError = YES THEN DO:
    MESSAGE 'Cliente (' s-codcli ') NO encontrado' SKIP
        'Comunicarse con el administrador del sistema' SKIP
        'Se continuará el cálculo asumiendo la clasificación C'
        VIEW-AS ALERT-BOX WARNING.
END.
ASSIGN
    x-ClfCli  = "C"         /* Valores por defecto */
    x-ClfCli2 = "C".
IF AVAIL gn-clie AND gn-clie.clfcli <> ''  THEN x-ClfCli  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

/* **************************************************************************** */
/* ESPECIAL: 10/12/2012                                                         */
/* LINEA = "011" SE CONSIDERA CLASIFICACION "C" + DSCTO X VOL (SIN PROMOCIONES) */
/* **************************************************************************** */
/* POR AHORA SOLO PARA EL ADMINISTRADOR */
IF Almmmatg.CodFam = "011" /*AND s-User-Id = "ADMIN"*/ THEN
    ASSIGN
        x-FlgDtoVol = YES
        x-FlgDtoProm = NO
        x-FlgDtoClfCli = YES
        x-FlgDtoCndVta = YES
        x-Libre_C01 = "A"           /* ACUMULATIVAS */
        x-ClfCli = "C"              /* FORZAMOS A "C" */
        x-ClfCli2 = "C"
        s-CndVta = "000".           /* FORZAMOS LA CONDICION DE VENTA */

/* ****************************************************************** */
/* PRECIO DE VENTA Y DESCUENTOS PROMOCIONALES O POR VOLUMEN DE VENTA  */
/* ****************************************************************** */
CASE gn-divi.VentaMayorista:
    WHEN 1 THEN DO:
        RUN Precio-Empresa.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    WHEN 2 THEN DO:
        RUN Precio-Division.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
END CASE.
/* ****************************************************************** */

/* ***************************************************************************************** */
/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
/* ***************************************************************************************** */
z-Dsctos = 0.
IF y-Dsctos = 0 THEN DO:
    FIND FIRST VtaDtoEsp WHERE Vtadtoesp.codcia = s-codcia
        AND Vtadtoesp.coddiv = s-coddiv
        AND TODAY >= Vtadtoesp.FechaD 
        AND TODAY <= Vtadtoesp.FechaH
        NO-LOCK NO-ERROR.
    FIND gn-convt WHERE gn-ConVt.Codig = s-cndvta NO-LOCK NO-ERROR.
    IF AVAILABLE Vtadtoesp AND AVAILABLE gn-convt THEN DO:
        CASE Almmmatg.CHR__02:
            WHEN "P" THEN DO:       /* PROPIOS */
                IF gn-ConVt.TipVta = "1" THEN z-Dsctos = VtaDtoEsp.DtoPropios[1].   /* CONTADO */
                IF gn-ConVt.TipVta = "2" THEN z-Dsctos = VtaDtoEsp.DtoPropios[2].   /* CREDITO */
            END.
            WHEN "T" THEN DO:       /* TERCEROS */
                IF gn-ConVt.TipVta = "1" THEN z-Dsctos = VtaDtoEsp.DtoTerceros[1].   /* CONTADO */
                IF gn-ConVt.TipVta = "2" THEN z-Dsctos = VtaDtoEsp.DtoTerceros[2].   /* CREDITO */
            END.
        END CASE.
    END.
END.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuento-por-ClfCli-y-CndVta) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuento-por-ClfCli-y-CndVta Procedure 
PROCEDURE Descuento-por-ClfCli-y-CndVta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ************************************************************* */
/* DESCUENTOS POR CLASIFICACION DE CLIENTES Y CONDICION DE VENTA */
/* ************************************************************* */
/* AHORA DEPENDE SI EL PRODUCTO ES PROPIO O DE TERCEROS */
/* DESCUENTO POR CLASIFICACION DEL PRODUCTO */
IF Almmmatg.chr__02 = "P" THEN DO:  /* PROPIOS */
    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc.
END.
ELSE DO:        /* TERCEROS */
    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI2 NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN MaxCat = ClfClie.PorDsc1.
END.

/* DESCUENTO POR CONDICION DE VENTA Y TIPO DE PRODUCTO */    
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND  Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

/* CONFIGURACION DE DESCUENTOS DE LA DIVISION */
IF x-FlgDtoClfCli = NO THEN MaxCat = 0.   /* Descuento por Clasificacion */
ELSE IF x-ClfCli = 'C' AND GN-DIVI.PorDtoClfCli > 0 THEN MaxCat = GN-DIVI.PorDtoClfCli.

IF x-FlgDtoCndVta = NO THEN MaxVta = 0.   /* Descuento por Condicion de Venta */
/* DESCUENTO TOTAL APLICADO */    
F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.     /* <<< OJO */
/* ************************************************************* */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Descuento-por-Volumen-y-Promocion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuento-por-Volumen-y-Promocion Procedure 
PROCEDURE Descuento-por-Volumen-y-Promocion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Por Volumen de Venta o Promoción (en ese orden)
------------------------------------------------------------------------------*/


/* DESCUENTOS EXCLUYENTES: EL PRECIO BASE SE RECALCULA */
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND gn-convt.totdias <= 15 THEN DO:
    /************ Descuento Promocional ************/ 
    IF x-FlgDtoProm = YES THEN DO:
        DO J = 1 TO 10:
            IF Almmmatg.PromDivi[J] = S-CODDIV 
                    AND TODAY >= Almmmatg.PromFchD[J] 
                    AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
                ASSIGN
                    F-PREVTA = Almmmatg.Prevta[1]   /* Precio de Lista */
                    Y-DSCTOS = Almmmatg.PromDto[J]
                    X-TIPDTO = "PROM".
                IF Almmmatg.Monvta = 1 THEN 
                    ASSIGN 
                    X-PREVTA1 = F-PREVTA
                    X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                ELSE
                    ASSIGN 
                        X-PREVTA2 = F-PREVTA
                        X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                ASSIGN
                    X-PREVTA1 = X-PREVTA1 * F-FACTOR
                    X-PREVTA2 = X-PREVTA2 * F-FACTOR.             
             END.   
        END.
    END.
    /*************** Descuento por Volumen ****************/
    IF x-FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED * F-FACTOR.
        DO J = 1 TO 10:
            IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
                IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = Almmmatg.DtoVolR[J]
                        F-PREVTA = Almmmatg.Prevta[1]   /* Precio de Lista */
                        Y-DSCTOS = Almmmatg.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                    IF Almmmatg.MonVta = 1 THEN 
                        ASSIGN 
                            X-PREVTA1 = F-PREVTA
                            X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                    ELSE
                        ASSIGN 
                            X-PREVTA2 = F-PREVTA
                            X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                    ASSIGN
                        X-PREVTA1 = X-PREVTA1 * F-FACTOR
                        X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                        
                END.   
            END.   
        END.
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1. ELSE F-PREVTA = X-PREVTA2.     
        IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1. ELSE F-PREBAS = X-PREVTA2.     
    END.    
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Descuento-por-Volumen-y-Promocion-Divi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuento-por-Volumen-y-Promocion-Divi Procedure 
PROCEDURE Descuento-por-Volumen-y-Promocion-Divi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* DESCUENTOS EXCLUYENTES: EL PRECIO BASE SE RECALCULA */
/************ Descuento Promocional ************/ 
IF x-FlgDtoProm = YES THEN DO:
    IF TODAY >= VtaListaMay.PromFchD AND TODAY <= VtaListaMay.PromFchH THEN DO:
        ASSIGN
            F-PREVTA = VtaListaMay.PreOfi
            Y-DSCTOS = VtaListaMay.PromDto
            X-TIPDTO = "PROM".
        IF VtaListaMay.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / VtaListaMay.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * VtaListaMay.TpoCmb,6).
        X-PREVTA1 = X-PREVTA1.
        X-PREVTA2 = X-PREVTA2.
     END.   
END.
/*************** Descuento por Volumen ****************/
IF x-FlgDtoVol = YES THEN DO:
    X-CANTI = X-CANPED.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaListaMay.DtoVolR[J] AND VtaListaMay.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaListaMay.DtoVolR[J].
            IF X-RANGO <= VtaListaMay.DtoVolR[J] THEN DO:
                ASSIGN
                    X-RANGO  = VtaListaMay.DtoVolR[J]
                    F-PREVTA = VtaListaMay.PreOfi
                    Y-DSCTOS = VtaListaMay.DtoVolD[J]
                    X-TIPDTO = "PROM".
                IF VtaListaMay.MonVta = 1 THEN 
                   ASSIGN X-PREVTA1 = F-PREVTA
                          X-PREVTA2 = ROUND(F-PREVTA / VtaListaMay.TpoCmb,6).
                ELSE
                   ASSIGN X-PREVTA2 = F-PREVTA
                          X-PREVTA1 = ROUND(F-PREVTA * VtaListaMay.TpoCmb,6).
                X-PREVTA1 = X-PREVTA1.
                X-PREVTA2 = X-PREVTA2.
            END.   
        END.   
    END.
END.
/* PRECIO FINAL */
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
    IF S-CODMON = 1 
    THEN F-PREBAS = X-PREVTA1.
    ELSE F-PREBAS = X-PREVTA2.     
END.    

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

/* DESCUENTO POR CLASIFICACION DEL CLIENTE */
ASSIGN
    MaxCat = 0.
/* DESCUENTO POR CONDICION DE VENTA */    
ASSIGN
    MaxVta = 0.
/* DESCUENTO TOTAL APLICADO */    
F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.

FIND FIRST Almmmatp OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatp THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' s-CodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.

/*IF s-UndVta = "" THEN s-UndVta = Almmmatp.Chr__01.*/
s-UndVta = Almmmatp.Chr__01.

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatp.codmat SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatp.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF Almmmatp.MonVta = 1 
    THEN ASSIGN F-PREBAS = Almmmatp.PreOfi * f-Factor.
    ELSE ASSIGN F-PREBAS = Almmmatp.PreOfi * S-TPOCMB * f-Factor.
END.
IF S-CODMON = 2 THEN DO:
    IF Almmmatp.MonVta = 2 
    THEN ASSIGN F-PREBAS = Almmmatp.PreOfi * f-Factor.
    ELSE ASSIGN F-PREBAS = (Almmmatp.PreOfi / S-TPOCMB) * f-Factor.
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */


/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
    /************ Descuento Promocional ************/ 
    DO J = 1 TO 10:
        IF Almmmatp.PromDivi[J] = S-CODDIV 
                AND TODAY >= Almmmatp.PromFchD[J] 
                AND TODAY <= Almmmatp.PromFchH[J] THEN DO:
            F-DSCTOS = 0.
            F-PREVTA = Almmmatp.PreOfi * f-Factor.
            Y-DSCTOS = Almmmatp.PromDto[J].
            IF Almmmatp.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / Almmmatp.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * Almmmatp.TpoCmb,6).
            X-PREVTA1 = X-PREVTA1 * F-FACTOR.
            X-PREVTA2 = X-PREVTA2 * F-FACTOR.             
         END.   
    END.
    /* PRECIO FINAL */
    IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
        IF S-CODMON = 1 THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
        IF S-CODMON = 1 THEN F-PREBAS = X-PREVTA1.
        ELSE F-PREBAS = X-PREVTA2.     
    END.    

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.

RETURN "OK".

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

/* PRECIO BASE Y UNIDAD DE VENTA */
FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMay THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' s-CodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    F-PreBas = VtaListaMay.PreOfi
    s-UndVta = VtaListaMay.Chr__01.
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu
    s-tpocmb = VtaListaMay.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMay.MonVta = 1 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMay.MonVta = 2 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) * F-FACTOR.
END.

/* CALCULAMOS PRECIOS Y DESCUENTOS DE ACUERDO A LA CONFIGURACIÓN DE LA DIVISIÓN */
ASSIGN 
    F-DSCTOS = 0    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0.   /* Dcto por Volumen o Promocional */
/* POR PRIORIDADES EXCLUYENTES */
IF x-Libre_C01 = "" THEN DO:      
    IF x-FlgDtoVol = YES OR x-FlgDtoProm = YES THEN DO:
        RUN Descuento-por-Volumen-y-Promocion-Divi.
    END.
    IF x-FlgDtoClfCli = YES OR x-FlgDtoCndVta = YES THEN DO:
        IF Y-DSCTOS = 0 THEN RUN Descuento-por-ClfCli-y-CndVta.
    END.
END.
/* POR PRIORIDADES ACUMULATIVAS */
IF x-Libre_C01 = "A" THEN DO:     /* ACUMULATIVAS */
    IF x-FlgDtoClfCli = YES OR x-FlgDtoCndVta = YES THEN DO:
        RUN Descuento-por-ClfCli-y-CndVta.
    END.
    IF x-FlgDtoProm = YES THEN DO:
        IF TODAY >= VtaListaMay.PromFchD AND TODAY <= VtaListaMay.PromFchH THEN DO:
            ASSIGN
                Y-DSCTOS = VtaListaMay.PromDto
                X-TIPDTO = "PROM".
         END.   
    END.
    /*************** Descuento por Volumen ****************/
    IF x-FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED.
        DO J = 1 TO 10:
            IF X-CANTI >= VtaListaMay.DtoVolR[J] AND VtaListaMay.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = VtaListaMay.DtoVolR[J].
                IF X-RANGO <= VtaListaMay.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = VtaListaMay.DtoVolR[J]
                        Y-DSCTOS = VtaListaMay.DtoVolD[J]
                        X-TIPDTO = "PROM".
                END.   
            END.   
        END.
    END.
END.
/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/*
/* NOTA: En caso de PROVINCIAS (DIV 00018) se va a tener 2 listas de precios:
Una para la division 00018 y otra para la division 10018.
La lista se tomará de acuerdo a la configuración del cliente */

CASE s-coddiv:
    WHEN "00018" THEN DO:
        /* buscamos a qué lista pertenece el cliente */
        FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
            AND VtaTabla.Tabla = "PL1"      /* Provincia Lista 1 */
            AND VtaTabla.Llave_c1 = s-codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE VtaTabla 
        THEN FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = "00018" NO-LOCK NO-ERROR.
        ELSE FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = "10018" NO-LOCK NO-ERROR.
        IF AVAILABLE VtaListaMay THEN DO:
            /* NO VA A TENER DESCUENTOS POR CLASIFICACION NI POR COND DE VTA */
            F-DSCTOS = 0.00.
            /* ************************************************************* */
        END.
        ELSE DO:
            /* EN CASO DE NO ESTAR REGISTRADO EN LA LISTA MAYORISTA SIGUE LA RUTINA DE PRECIOS GENERAL */
            RUN Precio-Empresa.
            IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
            RETURN "OK".
        END.
    END.
    OTHERWISE DO:
        /* LISTA DE PRECIO POR DIVISION */
        FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
        IF NOT AVAILABLE VtaListaMay THEN DO:
            IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' s-CodDiv
                VIEW-AS ALERT-BOX WARNING.
            RETURN "ADM-ERROR".
        END.
    END.
END CASE.
/* *************************************************************************************** */
ASSIGN
    s-UndVta = VtaListaMay.Chr__01
    s-tpocmb = VtaListaMay.TpoCmb.     /* ¿? */
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.
/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMay.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaMay.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMay.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMay.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaMay.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMay.PreOfi / S-TPOCMB).
END.
/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* ***************************************************************************************** */
/* ************** DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA *************** */
/* LISTA POR DIVISION OCURRE PARA EXPOLIBRERIA Y PROVINCIAS */
/* ***************************************************************************************** */
Y-DSCTOS = 0.        
/************ Descuento Promocional ************/ 
IF GN-DIVI.FlgDtoProm = YES THEN DO:
    IF TODAY >= VtaListaMay.PromFchD AND TODAY <= VtaListaMay.PromFchH THEN DO:
        ASSIGN
            F-DSCTOS = 0
            F-PREVTA = VtaListaMay.PreOfi
            Y-DSCTOS = VtaListaMay.PromDto
            X-TIPDTO = "PROM".
        IF VtaListaMay.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / VtaListaMay.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * VtaListaMay.TpoCmb,6).
        X-PREVTA1 = X-PREVTA1.
        X-PREVTA2 = X-PREVTA2.
     END.   
END.
/*************** Descuento por Volumen ****************/
IF GN-DIVI.FlgDtoVol = YES THEN DO:
    X-CANTI = X-CANPED.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaListaMay.DtoVolR[J] AND VtaListaMay.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaListaMay.DtoVolR[J].
            IF X-RANGO <= VtaListaMay.DtoVolR[J] THEN DO:
                ASSIGN
                    X-RANGO  = VtaListaMay.DtoVolR[J]
                    F-DSCTOS = 0
                    F-PREVTA = VtaListaMay.PreOfi
                    Y-DSCTOS = VtaListaMay.DtoVolD[J]
                    X-TIPDTO = "PROM".
                IF VtaListaMay.MonVta = 1 THEN 
                   ASSIGN X-PREVTA1 = F-PREVTA
                          X-PREVTA2 = ROUND(F-PREVTA / VtaListaMay.TpoCmb,6).
                ELSE
                   ASSIGN X-PREVTA2 = F-PREVTA
                          X-PREVTA1 = ROUND(F-PREVTA * VtaListaMay.TpoCmb,6).
                X-PREVTA1 = X-PREVTA1.
                X-PREVTA2 = X-PREVTA2.
            END.   
        END.   
    END.
END.
/* PRECIO FINAL */
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
    IF S-CODMON = 1 
    THEN F-PREBAS = X-PREVTA1.
    ELSE F-PREBAS = X-PREVTA2.     
END.    

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
*/

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

/* PRECIO BASE Y UNIDAD DE VENTA */
ASSIGN
    F-PreBas = Almmmatg.PreOfi.
    s-UndVta = Almmmatg.Chr__01.
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu
    s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */

/* PRECIO BASE  */

IF S-CODMON = 1 THEN DO:
    IF Almmmatg.MonVta = 1 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF Almmmatg.MonVta = 2 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) * F-FACTOR.
END.

/* CALCULAMOS PRECIOS Y DESCUENTOS DE ACUERDO A LA CONFIGURACIÓN DE LA DIVISIÓN */
ASSIGN 
    F-DSCTOS = 0    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0.   /* Dcto por Volumen o Promocional */
/* POR PRIORIDADES EXCLUYENTES */
IF x-Libre_C01 = "" THEN DO:      
    IF x-FlgDtoVol = YES OR x-FlgDtoProm = YES THEN DO:
        RUN Descuento-por-Volumen-y-Promocion.
    END.
    IF x-FlgDtoClfCli = YES OR x-FlgDtoCndVta = YES THEN DO:
        IF Y-DSCTOS = 0 THEN RUN Descuento-por-ClfCli-y-CndVta.
    END.
END.
/* POR PRIORIDADES ACUMULATIVAS */
IF x-Libre_C01 = "A" THEN DO:     
    IF x-FlgDtoClfCli = YES OR x-FlgDtoCndVta = YES THEN DO:
        RUN Descuento-por-ClfCli-y-CndVta.
    END.
    /************ Descuento Promocional ************/ 
    IF x-FlgDtoProm = YES THEN DO:
        DO J = 1 TO 10:
            IF Almmmatg.PromDivi[J] = S-CODDIV 
                AND TODAY >= Almmmatg.PromFchD[J] 
                AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
                ASSIGN
                    Y-DSCTOS = Almmmatg.PromDto[J]
                    X-TIPDTO = "PROM".
            END.
        END.
    END.
    /*************** Descuento por Volumen ****************/
    IF x-FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED * F-FACTOR .
        DO J = 1 TO 10:
            IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
                IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = Almmmatg.DtoVolR[J]
                        Y-DSCTOS = Almmmatg.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                END.   
            END.   
        END.
    END.
END.
/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Precio-Provincias) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Provincias Procedure 
PROCEDURE Precio-Provincias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Buscamos cual es la lista activa del cliente */
FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Tabla = "PL1" 
    AND VtaTabla.Llave_c1 = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE VtaTabla THEN DO:      /* Buscamos Precios en la Lista # 1 */
    FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = "LP1" NO-LOCK NO-ERROR.
END.
ELSE DO:                            /* Buscamos Precios en la Lista # 2 */
    FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = "LP2" NO-LOCK NO-ERROR.
END.
IF NOT AVAILABLE VtaListaMay THEN RETURN "ADM-ERROR".
/* PRECIO BASE Y UNIDAD DE VENTA */
ASSIGN
    F-PreBas = VtaListaMay.PreOfi
    s-UndVta = VtaListaMay.Chr__01.
/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de venta:' s-UndVta
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
ASSIGN
    F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu
    s-tpocmb = VtaListaMay.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMay.MonVta = 1 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB * F-FACTOR.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMay.MonVta = 2 
        THEN ASSIGN F-PREBAS = F-PREBAS * F-FACTOR.
    ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB) * F-FACTOR.
END.

/* EN ESTE CASO SOLO SE VA A ACUMULAR PROMOCIONES */
ASSIGN 
    F-DSCTOS = 0    /* Dcto por ClfCli y/o Cnd Vta */
    Y-DSCTOS = 0.   /* Dcto por Volumen o Promocional */
IF x-FlgDtoVol = YES OR x-FlgDtoProm = YES THEN DO:
    RUN Descuento-por-Volumen-y-Promocion-Divi.
END.
/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

RETURN "OK".

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

/* FACTOR DE EQUIVALENCIA */
/*IF s-UndVta = "" THEN s-UndVta = Almmmatg.Chr__01.*/
s-UndVta = Almmmatg.Chr__01.
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndStk
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
    IF pError = YES THEN MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP
        '   Unidad Stock:' Almmmatg.UndStk SKIP
        'Unidad de Venta:' s-UndVta
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = 'REMATES'
    AND Vtatabla.llave_c1 = s-codmat
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla THEN DO:
    IF pError = YES THEN MESSAGE "Producto en REMATE NO tiene precio de venta"
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = VtaTabla.Valor[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * Almmmatg.TpoCmb, 6 ).
ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] / Almmmatg.TpoCmb, 6 ).
ASSIGN
    F-PREVTA = F-PREBAS * f-Factor.
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

