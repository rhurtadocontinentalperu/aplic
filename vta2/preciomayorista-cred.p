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
    MaxCat = 0
    MaxVta = 0
    F-PreBas = Almmmatg.PreOfi.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
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
/* RUN Precio-Empresa.                                    */
/* IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR". */

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


/* **********************  Internal Procedures  *********************** */

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

/* DESCUENTO POR CLASIFICACION DEL CLIENTE */
FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA AND gn-clie.CodCli = S-CODCLI NO-LOCK.
ASSIGN
    x-ClfCli  = "C"         /* Valor por defecto */
    x-ClfCli2 = "C".
IF NOT AVAILABLE gn-clie AND pError = YES THEN DO:
    MESSAGE 'Cliente (' s-codcli ') NO encontrado' SKIP
        'Comunicarse con el administrador del sistema' SKIP
        'Se continuará el cálculo asumiendo la clasificación C'
        VIEW-AS ALERT-BOX WARNING.
END.
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

/* DESCUENTOS POR CLASIFICACION DE CLIENTES */
FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
IF AVAIL ClfClie THEN DO:
  IF Almmmatg.Chr__02 = "P" THEN 
      MaxCat = ClfClie.PorDsc.
  ELSE 
      MaxCat = ClfClie.PorDsc1.
END.
/* DESCUENTO POR CONDICION DE VENTA */    
FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
    AND  Dsctos.clfCli = Almmmatg.Chr__02
    NO-LOCK NO-ERROR.
IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

/* **************** FILTROS FINALES POR CONFIGURACION DE LA DIVISION ******************* */
IF GN-DIVI.FlgDtoClfCli = NO THEN MaxCat = 0.
ELSE IF x-ClfCli = 'C' AND GN-DIVI.PorDtoClfCli > 0 THEN MaxCat = GN-DIVI.PorDtoClfCli.
IF GN-DIVI.FlgDtoCndVta = NO THEN MaxVta = 0.
/* ************************************************************************************* */

/* *********************** DESCUENTO TOTAL APLICADO ************************* */    
F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
/* ************************************************************************** */

FIND FIRST VtaListaMay OF Almmmatg WHERE VtaListaMay.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMay THEN DO:
    IF pError = YES THEN MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' s-CodDiv
        VIEW-AS ALERT-BOX WARNING.
    RETURN "ADM-ERROR".
END.
/*IF s-UndVta = "" THEN s-UndVta = VtaListaMay.Chr__01.*/
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
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = VtaListaMay.TpoCmb.     /* ¿? */

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
/* ***************************************************************************************** */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
/* PARCHE PARA EXPOLIBRERIA: TODO PASA POR DESCUENTO PROMOCIONAL */
DEF VAR x-TotDias AS INT.
x-TotDias = 0.
IF AVAILABLE gn-convt THEN x-TotDias = gn-convt.totdias.
IF LOOKUP(s-CodDiv, '00015,00018,10018') > 0 THEN x-TotDias = 0.
IF LOOKUP(s-CodDiv, '00018,10018') = 0 AND s-CndVta = '002' THEN x-TotDias = 100.
/* FIN DEL PARCHE */
IF AVAILABLE gn-convt AND x-TotDias <= 15 /*AND gn-ConVt.Codig <> '002'*/ THEN DO:
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
END.
/* RHC 18/10/2012 PARCHE PARA PROVINCIAS - EXPO */
IF TODAY <= 03/31/2013
    AND LOOKUP(s-coddiv, '00018,10018,00015' ) > 0
    AND (x-ClfCli = "A" OR
         x-ClfCli = "A1" OR
         x-ClfCli = "B" OR
         x-ClfCli = "B1" OR
         x-ClfCli = "B2" OR
         x-ClfCli = "B3")
    THEN DO:
    CASE x-ClfCli:
        WHEN 'A' THEN MaxCat = 15.
        WHEN 'A1' THEN MaxCat = 14.
        WHEN 'B' THEN MaxCat = 13.
        WHEN 'B1' THEN MaxCat = 12.
        WHEN 'B2' THEN MaxCat = 11.
        WHEN 'B3' THEN MaxCat = 10.
    END CASE.
    /* DESCUENTO TOTAL APLICADO */    
    /* Se supone que no hay descuento por clasificación del cliente ni por condición de venta */
    F-DSCTOS = (1 - ((1 - MaxCat / 100) / 0.92)) * 100.
    F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
END.
/* ******************************************** */

/************************************************/
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

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
/* RHC 03.03.2011 FACTOR de ajuste al precio por cambio de IGV */
DEF VAR x-Factor-Igv AS DEC DECIMALS 6 NO-UNDO.
x-Factor-Igv = 1.
FIND FacCfgGn WHERE Faccfggn.codcia = s-codcia NO-LOCK.
FIND Vtatabla WHERE Vtatabla.codcia = s-codcia
    AND Vtatabla.tabla = "XIGV"
    AND VtaTabla.Llave_c1 = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE Vtatabla THEN DO:
    CASE Almmmatg.CHR__02:
        WHEN "P" THEN DO:
            IF VtaTabla.Llave_c2 = 'Si' THEN x-Factor-Igv = FacCfgGn.MrgDis.
        END.
        WHEN "T" THEN DO:
            IF VtaTabla.Llave_c3 = 'Si' THEN x-Factor-Igv = FacCfgGn.MrgDis.
        END.
    END CASE.
    ASSIGN
        F-PreBas = Almmmatg.PreOfi * x-Factor-Igv.
END.
/* *********************************************************** */

ASSIGN
    x-ClfCli  = "C"         /* Valor por defecto */
    x-ClfCli2 = "C".
IF AVAIL gn-clie AND gn-clie.clfcli <> '' THEN X-CLFCLI  = gn-clie.clfcli.
IF AVAIL gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

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
/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */

/* Descuento por Clasificacion */
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.
IF LOOKUP(Almmmatg.CodFam, '000,001,002') > 0 AND LOOKUP(x-ClfCli2, x-Cols) > 0 THEN DO:
    /* Calculamos el margen de utilidad */
    DEF VAR x-MejPre AS DEC INIT 0 NO-UNDO.
    DEF VAR x-MejMar AS DEC INIT 0 NO-UNDO.
    x-MejPre = Almmmatg.PreOfi * 0.9312 *  x-Factor-Igv.    /* (- 4% - 3%) */
    IF Almmmatg.CtoTot > 0 THEN x-MejMar = ROUND ( ( x-MejPre - Almmmatg.CtoTot ) / Almmmatg.CtoTot * 100, 2).
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = s-codcia
        AND VtaTabla.Tabla = 'DTOTER'
        AND x-MejMar >= VtaTabla.Rango_valor[1] 
        AND x-MejMar <  VtaTabla.Rango_valor[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF LOOKUP(x-ClfCli2, x-Cols) > 0 THEN MaxCat = VtaTabla.Valor[LOOKUP(x-ClfCli2, x-Cols)].
    END.
    x-MejPre = x-MejPre * ( 1 - MaxCat / 100 ).
    MaxCat = ( 1 - ( x-MejPre / ( Almmmatg.PreOfi * 0.9312 * x-Factor-Igv)  ) ) * 100.
    /* PRECIO BASE Y VENTA  */
    ASSIGN
        F-PREBAS = Almmmatg.PreOfi * 0.9312
        F-PREVTA = x-MejPre
        F-DSCTOS = MaxCat.
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
    IF S-CODMON = 1 THEN DO:
        IF Almmmatg.MonVta = 1 
        THEN ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
        ELSE ASSIGN F-PREVTA = F-PREVTA * S-TPOCMB * F-FACTOR.
    END.
    IF S-CODMON = 2 THEN DO:
        IF Almmmatg.MonVta = 2 
        THEN ASSIGN F-PREVTA = F-PREVTA * F-FACTOR.
        ELSE ASSIGN F-PREVTA = (F-PREVTA / S-TPOCMB) * F-FACTOR.
    END.
END.
ELSE DO:
    FIND ClfClie WHERE ClfClie.Categoria = X-CLFCLI NO-LOCK NO-ERROR.
    IF AVAIL ClfClie THEN DO:
      IF Almmmatg.Chr__02 = "P" THEN 
          MaxCat = ClfClie.PorDsc.
      ELSE 
          MaxCat = ClfClie.PorDsc1.
    END.
    /* DESCUENTO POR CONDICION DE VENTA */    
    FIND Dsctos WHERE Dsctos.CndVta = S-CNDVTA
        AND  Dsctos.clfCli = Almmmatg.Chr__02
        NO-LOCK NO-ERROR.
    IF AVAIL Dsctos THEN MaxVta = Dsctos.PorDto.

    IF GN-DIVI.FlgDtoClfCli = NO THEN MaxCat = 0.
    ELSE IF x-ClfCli = 'C' AND GN-DIVI.PorDtoClfCli > 0 THEN MaxCat = GN-DIVI.PorDtoClfCli.
    IF GN-DIVI.FlgDtoCndVta = NO THEN MaxVta = 0.
    
    /* DESCUENTO TOTAL APLICADO */    
    F-DSCTOS = (1 - (1 - MaxCat / 100) * (1 - MaxVta / 100)) * 100.
    
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
END.
/* ********************************** */
/* RHC SOLO EN CASO DE DIVISION 00018 */
/* ********************************** */
IF s-coddiv = "00018" THEN DO:
    /************ Descuento Promocional ************/ 
    IF GN-DIVI.FlgDtoProm = YES THEN DO:
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
    IF GN-DIVI.FlgDtoVol = YES THEN DO:
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
    RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
    RETURN "OK".
END.
/* FIN DEL PARCHE PARA DIVISION 00018 */

/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
FIND gn-convt WHERE gn-convt.Codig = S-CNDVTA NO-LOCK NO-ERROR.
IF AVAILABLE gn-convt AND  gn-convt.totdias <= 15 THEN DO:
    /************ Descuento Promocional ************/ 
    IF GN-DIVI.FlgDtoProm = YES THEN DO:
        DO J = 1 TO 10:
            IF Almmmatg.PromDivi[J] = S-CODDIV 
                    AND TODAY >= Almmmatg.PromFchD[J] 
                    AND TODAY <= Almmmatg.PromFchH[J] THEN DO:
                ASSIGN
                    F-DSCTOS = 0
                    F-PREVTA = Almmmatg.Prevta[1]
                    Y-DSCTOS = Almmmatg.PromDto[J]
                    X-TIPDTO = "PROM".
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
                        Y-DSCTOS = Almmmatg.DtoVolD[J] 
                        X-TIPDTO = "VOL".
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
END.
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

