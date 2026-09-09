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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

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
s-tpocmb = {&Tabla}.TpoCmb.     /* ¿? */

/* PRECIO BASE  */
IF S-CODMON = 1 THEN DO:
    IF {&Tabla}.MonVta = 1 
    THEN ASSIGN F-PREBAS = {&Tabla}.PreOfi.
    ELSE ASSIGN F-PREBAS = {&Tabla}.PreOfi * S-TPOCMB.
END.
IF S-CODMON = 2 THEN DO:
    IF {&Tabla}.MonVta = 2 
    THEN ASSIGN F-PREBAS = {&Tabla}.PreOfi.
    ELSE ASSIGN F-PREBAS = ({&Tabla}.PreOfi / S-TPOCMB).
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
        IF TODAY >= {&Tabla}.PromFchD AND TODAY <= {&Tabla}.PromFchH THEN DO:
            ASSIGN
                F-DSCTOS = 0
                F-PREVTA = {&Tabla}.PreOfi
                Y-DSCTOS = {&Tabla}.PromDto
                X-TIPDTO = "PROM".
            IF {&Tabla}.Monvta = 1 THEN 
              ASSIGN X-PREVTA1 = F-PREVTA
                     X-PREVTA2 = ROUND(F-PREVTA / {&Tabla}.TpoCmb,6).
            ELSE
              ASSIGN X-PREVTA2 = F-PREVTA
                     X-PREVTA1 = ROUND(F-PREVTA * {&Tabla}.TpoCmb,6).
            X-PREVTA1 = X-PREVTA1.
            X-PREVTA2 = X-PREVTA2.
         END.   
    END.
    /*************** Descuento por Volumen ****************/
    IF GN-DIVI.FlgDtoVol = YES THEN DO:
        X-CANTI = X-CANPED.
        DO J = 1 TO 10:
            IF X-CANTI >= {&Tabla}.DtoVolR[J] AND {&Tabla}.DtoVolR[J] > 0  THEN DO:
                IF X-RANGO  = 0 THEN X-RANGO = {&Tabla}.DtoVolR[J].
                IF X-RANGO <= {&Tabla}.DtoVolR[J] THEN DO:
                    ASSIGN
                        X-RANGO  = {&Tabla}.DtoVolR[J]
                        F-DSCTOS = 0
                        F-PREVTA = {&Tabla}.PreOfi
                        Y-DSCTOS = {&Tabla}.DtoVolD[J] 
                        X-TIPDTO = "VOL".
                    IF {&Tabla}.MonVta = 1 THEN 
                       ASSIGN X-PREVTA1 = F-PREVTA
                              X-PREVTA2 = ROUND(F-PREVTA / {&Tabla}.TpoCmb,6).
                    ELSE
                       ASSIGN X-PREVTA2 = F-PREVTA
                              X-PREVTA1 = ROUND(F-PREVTA * {&Tabla}.TpoCmb,6).
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


