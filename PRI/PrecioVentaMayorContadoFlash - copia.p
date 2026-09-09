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
/* Los mensajes de error son controlados por el programa que lo llama */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

/* RHC 14/08/2015 Si necesitas sacar precios SIN aplicar descuentos
    entonces s-FlgSit = 'SINDESCUENTOS'
*/    
DEF VAR x-Ajuste-por-flete AS LOG NO-UNDO.

/* OJO: Configuración de la LISTA DE PRECIOS */
DEF VAR pSalesChannel AS CHAR NO-UNDO.

FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = s-CodDiv NO-LOCK.
ASSIGN
    pSalesChannel = TRIM(STRING(INTEGER(GN-DIVI.Grupo_Divi_GG)))
    x-Ajuste-por-flete = GN-DIVI.Campo-Log[4].  /* Factor de Ajuste por Flete */

DEF VAR SW-LOG1 AS LOGI NO-UNDO.

DEFINE VARIABLE X-FACTOR  AS DECI NO-UNDO.

FIND Almmmatg WHERE Almmmatg.codcia = s-codcia
    AND Almmmatg.codmat = s-codmat NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almmmatg THEN RETURN.

IF pCodAlm > '' THEN DO:
    FIND Almacen WHERE Almacen.codcia = s-codcia
        AND Almacen.codalm = pCodAlm NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Almacen THEN RETURN.
END.

DEF SHARED VAR CL-CODCIA AS INT.

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
         HEIGHT             = 4.69
         WIDTH              = 74.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* variables sacadas del include */
DEFINE VAR J AS INTEGER.
DEFINE VAR X-RANGO AS INTEGER INIT 0.   
DEFINE VAR X-CANTI AS DECI    INIT 0.   

/* FACTOR DE EQUIVALENCIA */
FIND Almtconv WHERE Almtconv.CodUnid  = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-undvta
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtconv THEN DO:
/*     MESSAGE 'NO está configurado el factor de equivalencia para el producto' Almmmatg.codmat SKIP */
/*         'Unidad de venta:' s-UndVta                                                               */
/*         VIEW-AS ALERT-BOX ERROR.                                                                  */
    pMensaje = 'NO está configurado el factor de equivalencia para el producto ' + Almmmatg.codmat + CHR(10) +
        'Unidad de venta: ' + s-UndVta.
    RETURN "ADM-ERROR".
END.
F-FACTOR = Almtconv.Equival.

ASSIGN
    X-FACTOR = 1
    SW-LOG1 = FALSE.

/* *********************************************************************************** */
/* RHC 04.04.2011 ALMACENES DE REMATE */
/* *********************************************************************************** */
IF AVAILABLE Almacen AND Almacen.Campo-C[3] = 'Si' THEN DO:
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
        RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).
        RETURN 'OK'.
    END.
END.
/* *********************************************************************************** */
/* RDP 17.08.10 Reduce a 4 decimales*/
RUN lib/RedondearMas (F-PREVTA, 4, OUTPUT F-PREVTA).
/* *********************************************************************************** */

FIND gn-clie WHERE gn-clie.codcia = cl-codcia AND gn-clie.codcli = s-codcli
    NO-LOCK NO-ERROR.

/* *************************************************************************** */
/* ******************* CALCULO GENERAL DEL PRECIO DE VENTA ******************* */
/* *************************************************************************** */
DEF VAR x-MonVta AS INTE NO-UNDO.       /* Moneda de venta de la lista de precios */
/*DEF VAR pMensaje AS CHAR NO-UNDO.*/
DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.
RUN web_api-pricing-preuni IN hProc (INPUT s-CodMat,
                                     INPUT pSalesChannel,
                                     "C",
                                     INPUT "000",           /* Contado */
                                     OUTPUT x-MonVta,
                                     OUTPUT s-TpoCmb,
                                     OUTPUT f-PreVta,       /* Precio descontado ClfCli y CndVta */
                                     OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
/*     MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR. */
    RETURN 'ADM-ERROR'.
END.

IF s-CodMon = x-MonVta THEN F-PREBAS = F-PREVTA.
ELSE IF s-CodMon = 1 THEN F-PREBAS = ROUND ( F-PREVTA * s-TpoCmb, 6 ).
                    ELSE F-PREBAS = ROUND ( F-PREVTA / s-TpoCmb, 6 ).

F-PREBAS = F-PREBAS * F-FACTOR.     /* Ajustamos a la unidad de venta */
F-PREVTA = F-PREBAS.

/* *********************************************************************************** */
/* DESCUENTO ADICIONALES POR PROMOCION Y POR VOLUMEN DE VENTA */
/* *********************************************************************************** */
RUN Descuentos.
/* *********************************************************************************** */
/* *********************************************************************************** */
/* RHC INCREMENTO AL PRECIO UNITARIO POR PAGAR CON TARJETA DE CREDITO */
/* Calculamos el margen de utilidad */
DEF VAR x-MargenUtilidad AS DEC NO-UNDO.
DEF VAR x-ImporteCosto AS DEC NO-UNDO.

CASE s-FlgSit:
    WHEN 'T' THEN DO:       /* PAGO CON TARJETA DE CREDITO */
        DEFINE VAR hCosto AS HANDLE NO-UNDO.
        DEFINE VAR LocalMonVta AS INTE NO-UNDO.
        DEFINE VAR LocalTpoCmb AS DECI NO-UNDO.
        DEFINE VAR LocalMensaje AS CHAR NO-UNDO.

        RUN web/web-library.p PERSISTENT SET hCosto.

        RUN web_api-pricing-ctoreposicion IN hCosto (s-CodDiv,
                                                    s-CodMat,
                                                    "C",
                                                    "000",
                                                    OUTPUT LocalMonVta,
                                                    OUTPUT LocalTpoCmb,
                                                    OUTPUT x-ImporteCosto,
                                                    OUTPUT LocalMensaje).
        DELETE PROCEDURE hCosto.

        IF s-CODMON <> LocalMonvta THEN DO:
            x-ImporteCosto = IF s-CODMON = 1 THEN x-ImporteCosto * LocalTpocmb ELSE x-ImporteCosto / LocalTpocmb.
        END.
        
        IF x-ImporteCosto > 0 THEN x-MargenUtilidad = ( (f-PreVta / f-Factor) - x-ImporteCosto ) / x-ImporteCosto * 100.
        IF x-MargenUtilidad < 0 THEN x-MargenUtilidad = 0.
        /*MESSAGE (f-PreVta / f-Factor) x-importecosto x-margenutilidad.*/

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
/* *************************************************************************** */
/* *************************************************************************** */
/* Determinamos el Flete Unitario */
/* *************************************************************************** */
/* 1ro. Factor Harold Segura */
/* *************************************************************************** */
RUN vtagn/flete-unitario-general-v01.p (s-CodMat,
                                        s-CodDiv,
                                        S-CODMON,
                                        f-Factor,
                                        OUTPUT f-FleteUnitario).
/* *************************************************************************** */
/* 2do. Factor Karin Rodhenberg */
/* *************************************************************************** */
/* RUN gn/factor-porcentual-flete-v2.p (INPUT s-coddiv,                     */
/*                                      INPUT s-CodMat,                     */
/*                                      INPUT-OUTPUT f-FleteUnitario,       */
/*                                      INPUT "N",     /*INPUT s-TpoPed, */ */
/*                                      INPUT f-factor,                     */
/*                                      INPUT s-CodMon).                    */
RUN gn/factor-porcentual-flete-v3.p (INPUT s-coddiv, 
                                     INPUT s-CodMat,
                                     INPUT-OUTPUT f-FleteUnitario, 
                                     INPUT "N",
                                     INPUT f-factor, 
                                     INPUT s-CodMon,
                                     INPUT f-PreVta).

RUN lib/RedondearMas (F-PREBAS, X-NRODEC, OUTPUT F-PREBAS).
RUN lib/RedondearMas (F-PREVTA, X-NRODEC, OUTPUT F-PREVTA).

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos Procedure 
PROCEDURE Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

Y-DSCTOS = 0.        
IF s-FlgSit = 'SINDESCUENTOS' THEN RETURN.
/* *********************************************************************************** */
/************ Descuento Promocional ************/
/* *********************************************************************************** */
DEF VAR x-Old-Descuento AS DEC NO-UNDO. 
DEF VAR x-DctoPromocional AS DEC NO-UNDO.
DEF VAR X-PREVTA1 AS DECI NO-UNDO.
DEF VAR X-PREVTA2 AS DECI NO-UNDO.

PROMOCIONAL:    /* RHC 25/03/2015 */
DO:
    IF Almmmatg.CodFam = "011" THEN LEAVE PROMOCIONAL.
    IF Almmmatg.CodFam = "013" AND Almmmatg.SubFam <> "014" THEN LEAVE PROMOCIONAL.
    /* Tomamos el mayor descuento */ 
    x-Old-Descuento = 0. 
    x-DctoPromocional = 0.
    FOR EACH VtaDctoProm NO-LOCK WHERE VtaDctoProm.CodCia = s-CodCia AND 
        VtaDctoProm.CodDiv = s-CodDiv AND 
        VtaDctoProm.CodMat = Almmmatg.CodMat AND 
        VtaDctoProm.FlgEst = "A" AND
        (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin): 
        x-DctoPromocional = VtaDctoProm.Descuento. 
        x-DctoPromocional = MAXIMUM(x-DctoPromocional, x-Old-Descuento). 
        x-Old-Descuento = x-DctoPromocional. 
    END. 
    IF x-DctoPromocional > 0 THEN DO:
        ASSIGN
            F-DSCTOS = 0
            Y-DSCTOS = x-DctoPromocional
            SW-LOG1 = TRUE
            X-TIPDTO = "PROM".
    END.
END.
/* *********************************************************************************** */
/*************** Descuento por Volumen ****************/
/* *********************************************************************************** */
DEF VAR x-DctoxVolumen AS DEC NO-UNDO.

FIND Almtconv WHERE Almtconv.CodUnid = Almmmatg.UndBas 
    AND Almtconv.Codalter = s-UndVta 
    NO-LOCK NO-ERROR.
IF AVAILABLE Almtconv 
THEN ASSIGN
        X-FACTOR = Almtconv.Equival.
ELSE ASSIGN 
        X-FACTOR = 1.
X-CANTI = X-CANPED * X-FACTOR.
x-DctoxVolumen = 0.
x-Rango = 0.
DO J = 1 TO 10:
   IF X-CANTI >= Almmmatg.DtoVolR[J] AND Almmmatg.DtoVolR[J] > 0  THEN DO:
      IF X-RANGO  = 0 THEN X-RANGO = Almmmatg.DtoVolR[J].
      IF X-RANGO <= Almmmatg.DtoVolR[J] THEN DO:
          ASSIGN
              X-RANGO  = Almmmatg.DtoVolR[J]
              F-DSCTOS = 0
              Y-DSCTOS = Almmmatg.DtoVolD[J] 
              SW-LOG1 = TRUE
              X-TIPDTO = "VOL".
          x-DctoxVolumen = Y-DSCTOS.
      END.   
   END.   
END.
/* ************************************************************************************** */
/* RHC 11/08/2020 Se toma el mejor precio: Cesar Camus */
/* ************************************************************************************** */
/* 23/06/2022 Parche pala la línea 011: siempre como terceros GDLL */

CASE TRUE:
    WHEN Almmmatg.CodFam = '011' THEN DO:
        IF (x-DctoPromocional > 0 OR x-DctoxVolumen > 0) THEN DO:
            IF F-PREVTA * (1 - (x-DctoPromocional / 100)) < F-PREVTA * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            ELSE ASSIGN
                Y-DSCTOS = x-DctoxVolumen    /* OJO */
                X-TIPDTO = "VOL".
        END.
    END.
    OTHERWISE DO:
        /* Ic - 28Nov2022, Correo de Cesar Canus
            Por favor ampliar la regla de negocio para propios 
            Acabo de conversar con Gloria y no le afecta en su gestión esta regla  de negocio que funciona muy bien con Terceros
            
            Gracias        
        */
        /* IF (x-DctoPromocional > 0 OR x-DctoxVolumen > 0) AND Almmmatg.chr__02 = "T" THEN DO:  /* Solo Productos de Terceros */ */
        IF (x-DctoPromocional > 0 OR x-DctoxVolumen > 0) THEN DO:

            IF F-PREVTA * (1 - (x-DctoPromocional / 100)) < F-PREVTA * (1 - (x-DctoxVolumen / 100))
                THEN ASSIGN 
                Y-DSCTOS = x-DctoPromocional    /* OJO */
                X-TIPDTO = "PROM".
            ELSE ASSIGN
                Y-DSCTOS = x-DctoxVolumen    /* OJO */
                X-TIPDTO = "VOL".
        END.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

