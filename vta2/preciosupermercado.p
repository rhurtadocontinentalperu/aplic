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

DEF INPUT PARAMETER S-UNDVTA AS CHAR.
DEF INPUT PARAMETER f-Factor AS DEC.

DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-CNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.

DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.

DEF INPUT PARAMETER pError AS LOG.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.

/* VARIABLES LOCALES */
DEF VAR S-TPOCMB AS DEC NO-UNDO.
DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
/************ Descuento Promocional ************/
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.

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
         HEIGHT             = 5.62
         WIDTH              = 60.
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
    F-PreBas = Almmmatg.PreOfi.
/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.
/* DESCUENTO POR CLASIFICACION DEL CLIENTE */
FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA 
    AND gn-clie.CodCli = S-CODCLI 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie AND pError = YES THEN DO:
    MESSAGE 'Cliente (' s-codcli ') NO encontrado' SKIP
        'Comunicarse con el administrador del sistema' SKIP
        'Se continuará el cálculo asumiendo la clasificación C'
        VIEW-AS ALERT-BOX WARNING.
END.
/* *********************************************************** */
/* FACTOR DE EQUIVALENCIA */
/*s-UndVta = Almmmatg.Chr__01.*/
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
/* RHC 12.06.08 tipo de cambio de la familia */
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

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
/* IF AVAILABLE gn-convt AND  gn-convt.totdias <= 15 THEN DO: */
    /************ Descuento Promocional ************/ 
    IF GN-DIVI.FlgDtoProm = YES THEN DO:
        DO J = 1 TO 10:
            IF Almmmatg.PromDivi[J] = S-CODDIV 
                    AND TODAY >= Almmmatg.PromFchD[J] 
                    AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
                ASSIGN
                    F-DSCTOS = 0
                    F-PREVTA = Almmmatg.Prevta[1]
                    Y-DSCTOS = Almmmatg.PromDto[J].
                IF Almmmatg.Monvta = 1 THEN 
                  ASSIGN X-PREVTA1 = F-PREVTA
                         X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                ELSE
                  ASSIGN X-PREVTA2 = F-PREVTA
                         X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                X-PREVTA1 = X-PREVTA1 * F-FACTOR.
                X-PREVTA2 = X-PREVTA2 * F-FACTOR.             
             END.   
        END.
    END.
    /*************** Descuento por Volumen ****************/
    IF GN-DIVI.FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED * F-FACTOR .
        DO J = 1 TO 10:
            IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
                IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = Almmmatg.DtoVolR[J]
                        F-DSCTOS = 0
                        F-PREVTA = Almmmatg.Prevta[1]
                        Y-DSCTOS = Almmmatg.DtoVolD[J].
                    IF Almmmatg.MonVta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
                    X-PREVTA1 = X-PREVTA1 * F-FACTOR.
                    X-PREVTA2 = X-PREVTA2 * F-FACTOR.                                        
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
/* END. */
/************************************************/

    /* Descuento o Incremento de Precio Final */
/*     FIND FacTabla WHERE FacTabla.CodCia = s-codcia                  */
/*         AND FacTabla.Tabla = 'AU'                                   */
/*         AND FacTabla.Codigo = s-codcli                              */
/*         NO-LOCK NO-ERROR.                                           */
/*     IF AVAILABLE Factabla THEN DO:                                  */
/*         f-PreBas = f-PreVta.                                        */
/*         IF Factabla.Valor[1] <> 0                                   */
/*         THEN f-PreVta = f-PreBas * ( 1 - Factabla.Valor[1] / 100 ). */
/*         ELSE f-PreVta = f-PreBas * ( 1 + Factabla.Valor[2] / 100 ). */
/*     END.                                                            */
    /* *************************************** */

RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

/* DESCUENTO ESPECIAL POR EVENTO Y POR DIVISION (SOLO SI NO TIENE DESCUENTO POR VOL O PROMO) */
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


