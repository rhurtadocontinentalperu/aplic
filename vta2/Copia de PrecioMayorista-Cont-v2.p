&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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
         HEIGHT             = 5.62
         WIDTH              = 49.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER S-CODCIA AS INT.
DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER F-FACTOR AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER S-FLGSIT AS CHAR.
DEF INPUT PARAMETER S-UNDVTA AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER pCodAlm AS CHAR.       /* PARA CONTROL DE ALMACENES DE REMATES */
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.

DEF VAR SW-LOG1 AS LOGI NO-UNDO.

DEFINE VARIABLE X-PREVTA1 AS DECI NO-UNDO.
DEFINE VARIABLE X-PREVTA2 AS DECI NO-UNDO.
DEFINE VARIABLE X-FACTOR  AS DECI NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

FIND Almacen WHERE Almacen.codcia = s-codcia
    AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN RETURN.

DEF SHARED VAR CL-CODCIA AS INT.

/* variables sacadas del include */
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

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

ASSIGN
    X-FACTOR = 1
    X-PREVTA1 = 0
    X-PREVTA2 = 0
    SW-LOG1 = FALSE.

/* RHC 04.04.2011 ALMACENES DE REMATE */
IF Almacen.Campo-C[3] = 'Si' THEN DO:
    FIND VtaTabla WHERE Vtatabla.codcia = s-codcia
        AND Vtatabla.tabla = 'REMATES'
        AND Vtatabla.llave_c1 = s-codmat
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        IF s-CodMon = Almmmatg.MonVta 
        THEN F-PREBAS = VtaTabla.Valor[1] * f-Factor.
        ELSE IF s-CodMon = 1 
            THEN F-PREBAS = ROUND ( VtaTabla.Valor[1] * f-Factor * Almmmatg.TpoCmb, 6 ).
            ELSE F-PREBAS = ROUND ( VtaTabla.Valor[1] * f-Factor / Almmmatg.TpoCmb, 6 ).
        ASSIGN
            F-PREVTA = F-PREBAS.
        RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).
        RETURN.
    END.
END.
/* ********************************* */


/*RDP 17.08.10 Reduce a 4 decimales*/
RUN BIN/_ROUND1(F-PreBas,4,OUTPUT F-PreBas).
/**************************/

/* PRECIOS PRODUCTOS DE TERCEROS */
DEF VAR x-ClfCli2 LIKE gn-clie.clfcli2 INIT 'C' NO-UNDO.
DEF VAR x-Cols AS CHAR INIT 'A++,A+,A-' NO-UNDO.

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie AND gn-clie.clfcli2 <> '' THEN x-ClfCli2 = gn-clie.clfcli2.

/****   PRECIO C    ****/
IF Almmmatg.UndC <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndC 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
/*     MESSAGE 'undc' SKIP           */
/*         'cantidad' x-canped SKIP  */
/*         'f-factor' f-factor SKIP  */
/*         'x-factor' x-factor SKIP. */
    IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[3].
        IF Almmmatg.MonVta = 1 THEN
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[4]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[4]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/****   PRECIO B    ****/
IF Almmmatg.UndB <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndB 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
/*     MESSAGE 'undb' SKIP           */
/*         'cantidad' x-canped SKIP  */
/*         'f-factor' f-factor SKIP  */
/*         'x-factor' x-factor SKIP. */
    IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[2].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[3]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[3]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.
/****   PRECIO A    ****/
IF Almmmatg.UndA <> "" AND NOT SW-LOG1 THEN DO:
    FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
        AND  Almtconv.Codalter = Almmmatg.UndA 
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
/*     MESSAGE 'unda' SKIP           */
/*         'cantidad' x-canped SKIP  */
/*         'f-factor' f-factor SKIP  */
/*         'x-factor' x-factor SKIP. */
    IF (x-CanPed * F-FACTOR) >= (0.25 * X-FACTOR) THEN DO:
        SW-LOG1 = TRUE.
        F-PREBAS = Almmmatg.PreVta[1].
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
    ELSE DO:
        SW-LOG1 = TRUE.
        F-DSCTOS = Almmmatg.dsctos[1].
        IF Almmmatg.MonVta = 1 THEN 
          ASSIGN X-PREVTA1 = Almmmatg.Prevta[2]
                 X-PREVTA2 = ROUND(X-PREVTA1 / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = Almmmatg.Prevta[2]
                 X-PREVTA1 = ROUND(X-PREVTA2 * Almmmatg.TpoCmb,6).
        X-PREVTA1 = (X-PREVTA1 / X-FACTOR) * F-FACTOR.
        X-PREVTA2 = (X-PREVTA2 / X-FACTOR) * F-FACTOR.
    END.
END.       
/* El F-PREBAS siempre = Almmmatg.PreVta[1] (Precio Lista) */
IF s-CodMon = Almmmatg.MonVta THEN F-PREBAS = Almmmatg.PreVta[1].
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( Almmmatg.PreVta[1] * Almmmatg.TpoCmb, 6 ).
                    ELSE F-PREBAS = ROUND ( Almmmatg.PreVta[1] / Almmmatg.TpoCmb, 6 ).
F-PREBAS = F-PREBAS * F-FACTOR.
IF X-PREVTA1 + X-PREVTA2 > 0 THEN DO:
    IF S-CODMON = 1 
    THEN F-PREVTA = X-PREVTA1.
    ELSE F-PREVTA = X-PREVTA2.     
END.      

/* ********************************************************** */
/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* ********************************************************** */
Y-DSCTOS = 0.        
/************ Descuento Promocional ************/
PROMOCIONAL:    /* RHC 25/03/2015 */
DO:
    IF Almmmatg.CodFam = "011" THEN LEAVE PROMOCIONAL.
    IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam <> "014" THEN LEAVE PROMOCIONAL.
    FIND FIRST VtaTabla WHERE VtaTabla.codcia = Almmmatg.codcia
        AND VtaTabla.tabla = "DTOPROLIMA"
        AND VtaTabla.llave_c1 = Almmmatg.codmat
        AND VtaTabla.llave_c2 = s-CodDiv
        AND TODAY >= VtaTabla.Rango_Fecha[1]
        AND TODAY <= VtaTabla.Rango_Fecha[2]
        NO-LOCK NO-ERROR.
    IF AVAILABLE VtaTabla THEN DO:
        ASSIGN
            F-DSCTOS = 0
            F-PREVTA = Almmmatg.Prevta[1]
            Y-DSCTOS = VtaTabla.Valor[1]
            SW-LOG1 = TRUE
            X-TIPDTO = "PROM".
        IF Almmmatg.Monvta = 1 THEN 
          ASSIGN X-PREVTA1 = F-PREVTA
                 X-PREVTA2 = ROUND(F-PREVTA / Almmmatg.TpoCmb,6).
        ELSE
          ASSIGN X-PREVTA2 = F-PREVTA
                 X-PREVTA1 = ROUND(F-PREVTA * Almmmatg.TpoCmb,6).
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
            AND Almtconv.Codalter = s-UndVta
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv
        THEN x-Factor = Almtconv.Equival.
        ELSE x-Factor = 1.
        X-PREVTA1 = X-PREVTA1 * X-FACTOR.
        X-PREVTA2 = X-PREVTA2 * X-FACTOR.             
        IF S-CODMON = 1 
        THEN F-PREVTA = X-PREVTA1.
        ELSE F-PREVTA = X-PREVTA2.     
/*         IF S-CODMON = 1            */
/*         THEN F-PREBAS = X-PREVTA1. */
/*         ELSE F-PREBAS = X-PREVTA2. */
    END.
END.
/*************** Descuento por Volumen ****************/
FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-UndVta 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almtconv 
THEN ASSIGN
        X-FACTOR = Almtconv.Equival.
ELSE ASSIGN 
        X-FACTOR = 1.
X-CANTI = X-CANPED * X-FACTOR.
DO J = 1 TO 10:
   IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
      IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
      IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
          ASSIGN
              X-RANGO  = Almmmatg.DtoVolR[J]
              F-DSCTOS = 0
              F-PREVTA = Almmmatg.Prevta[1]
              Y-DSCTOS = Almmmatg.DtoVolD[J] 
              SW-LOG1 = TRUE
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
      IF S-CODMON = 1 
      THEN F-PREVTA = X-PREVTA1.
      ELSE F-PREVTA = X-PREVTA2.     
/*       IF S-CODMON = 1            */
/*       THEN F-PREBAS = X-PREVTA1. */
/*       ELSE F-PREBAS = X-PREVTA2. */
   END.   
END.
/* RHC INCREMENTO AL PRECIO UNITARIO POR PAGAR CON TARJETA DE CREDITO */
/* Calculamos el margen de utilidad */
DEF VAR x-MargenUtilidad AS DEC NO-UNDO.
DEF VAR x-ImporteCosto AS DEC NO-UNDO.
x-ImporteCosto = Almmmatg.Ctotot.
IF s-CODMON <> Almmmatg.Monvta THEN DO:
    x-ImporteCosto = IF s-CODMON = 1 
                THEN Almmmatg.Ctotot * Almmmatg.Tpocmb
                ELSE Almmmatg.Ctotot / Almmmatg.Tpocmb.
END.
IF x-ImporteCosto > 0
THEN x-MargenUtilidad = ( (f-PreVta / f-Factor) - x-ImporteCosto ) / x-ImporteCosto * 100.
IF x-MargenUtilidad < 0 THEN x-MargenUtilidad = 0.
/*************************************************/
CASE s-FlgSit:
    WHEN 'T' THEN DO:       /* PAGO CON TARJETA DE CREDITO */
        /* BUSCAMOS EL RANGO ADECUADO */
        FOR EACH FacTabla NO-LOCK WHERE FacTabla.codcia = s-codcia
                AND FacTabla.Tabla = 'TC'
                AND FacTabla.Codigo BEGINS '00':
            IF x-MargenUtilidad >= FacTabla.Valor[1]
                    AND x-MargenUtilidad < FacTabla.Valor[2] THEN DO:
                f-PreVta = f-Prevta * (1 + FacTabla.Valor[3] / 100).
                f-PreBas = f-PreBas * (1 + FacTabla.Valor[3] / 100).
                LEAVE.
            END.
        END.                
    END.
END CASE.
/* ************************************************ */
/* RHC 19/11/2013 INCREMENTO POR DIVISION Y FAMILIA */
/* ************************************************ */
RUN Factor-de-Ajuste.
/* ************************************************ */

/* RHC 05/03/2014 PRECIO FINAL POR VOLUMEN SOLO PARA LA DIVISION 00060, 00061 Y 00062 */
/* FIND VtaTabla WHERE VtaTabla.codcia = s-codcia                                          */
/*     AND VtaTabla.Tabla = "DCTOVOLARE"                                                   */
/*     AND VtaTabla.Llave_c1 = Almmmatg.codmat                                             */
/*     NO-LOCK NO-ERROR.                                                                   */
/* IF s-CodDiv = "00060" AND TODAY <= 03/31/2014 AND AVAILABLE VtaTabla THEN DO:           */
/*     /* VALORES POR DEFECTO */                                                           */
/*     ASSIGN                                                                              */
/*         s-tpocmb = Almmmatg.TpoCmb.     /* ¿? */                                        */
/*     /*************** Descuento por Volumen ****************/                            */
/*     DEF VAR x-PrecioFinal AS DEC NO-UNDO.                                               */
/*     ASSIGN                                                                              */
/*         X-RANGO = 0                                                                     */
/*         X-CANTI = X-CANPED * F-FACTOR                                                   */
/*         x-PrecioFinal = 0.                                                              */
/*     DO J = 1 TO 10:                                                                     */
/*         IF X-CANTI >= VtaTabla.Valor[J] AND VtaTabla.Valor[J + 10] > 0  THEN DO:        */
/*             IF X-RANGO  = 0 THEN X-RANGO = VtaTabla.Valor[J].                           */
/*             IF X-RANGO <= VtaTabla.Valor[J] THEN DO:                                    */
/*                 ASSIGN                                                                  */
/*                     X-RANGO  = VtaTabla.Valor[J]                                        */
/*                     x-PrecioFinal = VtaTabla.Valor[J + 10].                             */
/*             END.                                                                        */
/*         END.                                                                            */
/*     END.                                                                                */
/*     IF x-PrecioFinal > 0 THEN DO:   /* SIEMPRE EN SOLES */                              */
/*         F-PREBAS = Almmmatg.PreVta[1].    /* OJO => Se cambia Precio Base */            */
/*         /* RHC 19/11/2013 INCREMENTO POR DIVISION Y FAMILIA */                          */
/*         FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia                                  */
/*             AND VtaTabla.Llave_c1 = s-coddiv                                            */
/*             AND VtaTabla.Llave_c2 = Almmmatg.codfam                                     */
/*             AND VtaTabla.Tabla = "DIVFACXLIN"                                           */
/*             NO-LOCK NO-ERROR.                                                           */
/*         IF AVAILABLE VtaTabla THEN f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100). */
/*         /* ******************************** */                                          */
/*         /* PRECIO BASE A LA MONEDA DE VENTA */                                          */
/*         /* ******************************** */                                          */
/*         IF S-CODMON = 1 THEN DO:                                                        */
/*             IF Almmmatg.MonVta = 1 THEN ASSIGN F-PREBAS = F-PREBAS.                     */
/*             ELSE ASSIGN F-PREBAS = F-PREBAS * S-TPOCMB.                                 */
/*         END.                                                                            */
/*         IF S-CODMON = 2 THEN DO:                                                        */
/*             IF Almmmatg.MonVta = 2 THEN ASSIGN F-PREBAS = F-PREBAS.                     */
/*             ELSE ASSIGN F-PREBAS = (F-PREBAS / S-TPOCMB).                               */
/*         END.                                                                            */
/*         ASSIGN                                                                          */
/*             F-PREVTA = F-PREBAS                                                         */
/*             Y-DSCTOS = ROUND(( 1 - (x-PrecioFinal / f-PreBas) ) * 100 , 4)              */
/*             X-TIPDTO = "VOL".                                                           */
/*     END.                                                                                */
/* END.                                                                                    */
/************************************************/
RUN BIN/_ROUND1(F-PREBAS,X-NRODEC,OUTPUT F-PREBAS).
RUN BIN/_ROUND1(F-PREVTA,X-NRODEC,OUTPUT F-PREVTA).

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Factor-de-Ajuste) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Factor-de-Ajuste Procedure 
PROCEDURE Factor-de-Ajuste :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*  NOTA:   
    En algunos casos afecta el precio en otros es el flete */
DEF VAR x-FactorFlete AS DEC NO-UNDO.

FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
    AND VtaTabla.Llave_c1 = s-coddiv
    AND VtaTabla.Llave_c2 = Almmmatg.codfam
    AND VtaTabla.Llave_c3 = Almmmatg.subfam
    AND VtaTabla.Tabla = "DIVFACXSLIN"
    NO-LOCK NO-ERROR.
CASE s-CodDiv:
    WHEN "00065" THEN DO:       /* FLETE */
        /* Se basa en el precio de la unidad A */
        x-FactorFlete = 0.
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN x-FactorFlete = VtaTabla.Valor[1] / 100.
        ELSE DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Llave_c1 = s-coddiv
                AND VtaTabla.Llave_c2 = Almmmatg.codfam
                AND VtaTabla.Tabla = "DIVFACXLIN"
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN x-FactorFlete = VtaTabla.Valor[1] / 100.
        END.
        /* Factor de ajuste */
        FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
            AND  Almtconv.Codalter = Almmmatg.UndA 
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almtconv THEN X-FACTOR = Almtconv.Equival.
        /* Flete ajustado a la unidad de venta */
        f-FleteUnitario = Almmmatg.PreVta[2] * x-FactorFlete / x-Factor * f-Factor.
        IF s-CodMon <> Almmmatg.MonVta 
            THEN IF s-CodMon = 1 
            THEN f-FleteUnitario = ROUND ( f-FleteUnitario * Almmmatg.TpoCmb, 6 ).
            ELSE f-FleteUnitario = ROUND ( f-FleteUnitario / Almmmatg.TpoCmb, 6 ).
    END.
    OTHERWISE DO:               /* PRECIO */
        IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN DO:
            f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100).
            f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100).
        END.
        ELSE DO:
            FIND VtaTabla WHERE VtaTabla.CodCia = s-codcia
                AND VtaTabla.Llave_c1 = s-coddiv
                AND VtaTabla.Llave_c2 = Almmmatg.codfam
                AND VtaTabla.Tabla = "DIVFACXLIN"
                NO-LOCK NO-ERROR.
            IF AVAILABLE VtaTabla AND VtaTabla.Valor[1] > 0 THEN DO:
                f-PreVta = f-Prevta * (1 + VtaTabla.Valor[1] / 100).
                f-PreBas = f-PreBas * (1 + VtaTabla.Valor[1] / 100).
            END.
        END.
        /* ************************************************ */
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

