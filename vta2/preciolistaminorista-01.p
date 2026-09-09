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
         HEIGHT             = 7.27
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
/*DEF INPUT PARAMETER x-codban AS CHAR.*/
DEF INPUT PARAMETER s-FlgSit AS CHAR.

DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.

/* VARIABLES GLOBALES */
DEF SHARED VAR S-CODCIA AS INT.
DEF SHARED VAR cl-codcia AS INT.

/* VARIABLES LOCALES */
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


/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
FIND Almmmatg WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN DO:
    MESSAGE 'Producto' s-CodMat 'NO registrado' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

ASSIGN
    MaxCat = 0
    MaxVta = 0
    F-PreBas = Almmmatg.PreOfi.

/* CONFIGURACIONES DE LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv NO-LOCK.

/* LISTAS DE PRECIOS */
CASE gn-divi.VentaMinorista:
    WHEN 1 THEN DO:
        RUN Precio-Empresa.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
    WHEN 2 THEN DO:
        RUN Precio-Division.
        IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    END.
END CASE.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Precio-Division) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Precio-Division Procedure 
PROCEDURE Precio-Division :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = s-CodDiv NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMin THEN DO:
    MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios de la división' s-CodDiv
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-UndVta = VtaListaMin.Chr__01.

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
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
s-tpocmb = VtaListaMin.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMin.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMin.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */


IF s-FlgSit = "C" AND (TODAY >= 02/19/2011 AND TODAY <= 03/05/2011) THEN DO:
    /* DESCUENTOS ESPECIALES POR PROMOCIONES */
    ASSIGN
        F-DSCTOS = 0.
    IF LOOKUP(Almmmatg.codfam, '000,011,008') = 0 THEN DO:
        ASSIGN
            Y-DSCTOS = 10.  /* << OJO >> */
    END.
    FIND FIRST VtaListaMin OF Almmmatg WHERE VtaListaMin.CodDiv = "99999" NO-LOCK NO-ERROR.
    IF AVAILABLE VtaListaMin THEN DO:
        ASSIGN
            Y-DSCTOS = 0.   /* << OJO >> */
        /* PRECIO BASE  */
        IF S-CODMON = 1 THEN DO:
            IF VtaListaMin.MonVta = 1 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = VtaListaMin.PreOfi * S-TPOCMB.
        END.
        IF S-CODMON = 2 THEN DO:
            IF VtaListaMin.MonVta = 2 
            THEN ASSIGN F-PREBAS = VtaListaMin.PreOfi.
            ELSE ASSIGN F-PREBAS = (VtaListaMin.PreOfi / S-TPOCMB).
        END.
        /* Definimos el precio de venta y el descuento aplicado */    
        F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */
    END.
    /* ************************************* */
END.
ELSE DO:
    /* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
    Y-DSCTOS = 0.        
    /************ Descuento Promocional ************/ 
    IF GN-DIVI.FlgDtoProm = YES THEN DO:
        IF TODAY >= VtaListaMin.PromFchD AND TODAY <= VtaListaMin.PromFchH THEN DO:
            ASSIGN
                F-DSCTOS = 0
                F-PREVTA = VtaListaMin.PreOfi
                Y-DSCTOS = VtaListaMin.PromDto
                X-TIPDTO = "PROM".
            IF VtaListaMin.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / VtaListaMin.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * VtaListaMin.TpoCmb,6).
            X-PREVTA1 = X-PREVTA1.
            X-PREVTA2 = X-PREVTA2.
         END.   
    END.
    /*************** Descuento por Volumen ****************/
    IF GN-DIVI.FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED.
        DO J = 1 TO 10:
            IF X-CANTI >= VtaListaMin.DtoVolR[J] AND VtaListaMin.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = VtaListaMin.DtoVolR[J].
                IF X-RANGO <= VtaListaMin.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = VtaListaMin.DtoVolR[J]
                        F-DSCTOS = 0
                        F-PREVTA = VtaListaMin.PreOfi
                        Y-DSCTOS = VtaListaMin.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                    IF VtaListaMin.MonVta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / VtaListaMin.TpoCmb,6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * VtaListaMin.TpoCmb,6).
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
END.

/* *********************************** */
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
/* *********************************** */

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.
            
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

FIND FIRST VtaListaMinGn OF Almmmatg NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaListaMinGn THEN DO:
    MESSAGE 'Producto' Almmmatg.CodMat 'NO definido en la lista de precios minorista'
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-UndVta = VtaListaMinGn.Chr__01.

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
F-FACTOR = Almtconv.Equival / Almmmatg.FacEqu.

/* RHC 12.06.08 tipo de cambio de la familia */
FIND Gn-TcVtaMin WHERE gn-tcvtamin.Codcia = s-codcia
    AND TODAY >= gn-tcvtamin.FechaIni 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-tcvtamin THEN DO:
    MESSAGE 'NO está definido el tipo de cambio' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
s-TpoCmb = gn-tcvtamin.venta.

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF VtaListaMinGn.MonVta = 1 
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = VtaListaMinGn.PreOfi * gn-tcvtamin.venta.
END.
IF S-CODMON = 2 THEN DO:
    IF VtaListaMinGn.MonVta = 2 
    THEN ASSIGN F-PREBAS = VtaListaMinGn.PreOfi.
    ELSE ASSIGN F-PREBAS = (VtaListaMinGn.PreOfi / gn-tcvtamin.compra).
END.

/* Definimos el precio de venta y el descuento aplicado */    
F-PREVTA = F-PREBAS * (1 - F-DSCTOS / 100).     /* Precio de venta descontado */


/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
Y-DSCTOS = 0.        
/************ Descuento Promocional ************/ 
IF GN-DIVI.FlgDtoProm = YES THEN DO:
    DO J = 1 TO 10:
        IF VtaListaMinGn.PromDivi[J] = S-CODDIV 
            AND TODAY >= VtaListaminGn.PromFchD[J] 
            AND TODAY <= VtaListaminGn.PromFchH[J] THEN DO:
            ASSIGN
                F-DSCTOS = 0
                F-PREVTA = VtaListaMinGn.PreOfi
                Y-DSCTOS = VtaListaMinGn.PromDto[J]
                X-TIPDTO = "PROM".
            IF VtaListaMinGn.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / gn-tcvtamin.compra,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * gn-tcvtamin.venta,6).
            X-PREVTA1 = X-PREVTA1.
            X-PREVTA2 = X-PREVTA2.
        END.
    END.
END.
/*************** Descuento por Volumen ****************/

IF GN-DIVI.FlgDtoVol = YES THEN DO:
    X-CANTI = X-CANPED.
    DO J = 1 TO 10:
        IF X-CANTI >= VtaListaMinGn.DtoVolR[J] AND VtaListaMinGn.DtoVolR[J] > 0  THEN DO:
            IF X-RANGO  = 0 THEN X-RANGO = VtaListaMinGn.DtoVolR[J].
            IF X-RANGO <= VtaListaMinGn.DtoVolR[J] THEN DO:
                ASSIGN
                    X-RANGO  = VtaListaMinGn.DtoVolR[J]
                    F-DSCTOS = 0
                    F-PREVTA = VtaListaMinGn.PreOfi
                    Y-DSCTOS = VtaListaMinGn.DtoVolD[J] 
                    X-TIPDTO = "VOL".
                IF VtaListaMinGn.MonVta = 1 THEN 
                   ASSIGN X-PREVTA1 = F-PREVTA
                          X-PREVTA2 = ROUND(F-PREVTA / gn-tcvtamin.compra,6).
                ELSE
                   ASSIGN X-PREVTA2 = F-PREVTA
                          X-PREVTA1 = ROUND(F-PREVTA * gn-tcvtamin.venta,6).
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

/* *********************************** */
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
/* *********************************** */

/* DESCUENTOS ADICIONALES POR DIVISION */
z-Dsctos = 0.


RETURN "OK".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

