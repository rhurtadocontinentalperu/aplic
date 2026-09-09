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

/* Programa que decide cuál rutina de precios va a usar
Depende si el peldaño es parte de la escalera de precios */

DEF INPUT PARAMETER s-TpoPed AS CHAR.   /* Tipo de Pedido */
/* Sintaxis: Por defecto trabaja con la LISTA MAYORISTA (Almmmatg y VtaListaMay)
Enviar 
"MIN" si va a trabajar con la LISTA MINORISTA VtaListaMinGn
"CREDMAY" si va a trabajar con la LISTA MAYORISTA CREDITO
"CONTMAY" si va a trabajar con la LISTA MAYORISTA CONTADO
*/    
DEF INPUT PARAMETER s-CodDiv AS CHAR.    /* Lista de Precios */
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.    /* SOlo por compatibilidad */
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.       /* Default 1 */
DEF INPUT PARAMETER s-FmaPgo AS CHAR.       /* Condicion de venta */     
DEF INPUT PARAMETER s-NroDec AS INT.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER pClfCli AS CHAR.        /* SOlo si tiene un valor me sirve */
DEF INPUT PARAMETER pCodAlm AS CHAR.       /* PARA CONTROL DE ALMACENES DE REMATES */
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.       /* Descuento incluidos */
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
DEF INPUT PARAMETER pError AS LOG.          /* Mostrar el error en pantalla: Solo por complatibilidad */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.
DEF VAR s-TipVta AS CHAR NO-UNDO.       /* Solo por compatibilidad */
DEF VAR s-codbco AS CHAR NO-UNDO.       /* Solo por compatibilidad */
DEF VAR s-tarjeta AS CHAR NO-UNDO.      /* Solo por compatibilidad */
DEF VAR s-codpro AS CHAR NO-UNDO.       /* Solo por compatibilidad */
DEF VAR s-NroVale AS CHAR NO-UNDO.      /* Solo por compatibilidad */


DEF VAR LogParteEscalera AS LOG INIT YES NO-UNDO.   /* Por defecto SI pertenece a la escalera de precios */

/* FIND gn-divi WHERE gn-divi.codcia = s-codcia                           */
/*     AND gn-divi.coddiv = pCodDiv                                       */
/*     NO-LOCK NO-ERROR.                                                  */
/* IF AVAILABLE gn-divi THEN DO:                                          */
/*     FIND FacTabla WHERE FacTabla.CodCia = s-CodCia                     */
/*         AND FacTabla.Tabla = 'GRUPO_DIVGG'                             */
/*         AND FacTabla.Codigo = GN-DIVI.Grupo_Divi_GG                    */
/*         NO-LOCK NO-ERROR.                                              */
/*     IF AVAILABLE FacTabla THEN LogParteEscalera = FacTabla.Campo-L[1]. */
/* END.                                                                   */
/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
DEFINE VAR hProc AS HANDLE NO-UNDO.
DEFINE VAR pSalesChannel AS CHAR NO-UNDO.

RUN web/web-library.p PERSISTENT SET hProc.
RUN web_api-captura-peldano-valido IN hProc (INPUT s-CodDiv,
                                             OUTPUT LogParteEscalera,
                                             OUTPUT pSalesChannel,
                                             OUTPUT pMensaje).
DELETE PROCEDURE hProc.
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.

/* *************************************************************************************** */
CASE LogParteEscalera:
    WHEN YES THEN DO:
        RUN pri/PrecioFinalMayoristaGeneral.p (
            s-TpoPed,
            s-CodDiv,
            s-CodCli,
            s-CodMon,
            s-CodMat,
            s-UndVta,
            OUTPUT f-Factor,
            s-FmaPgo,
            s-NroDec,
            x-CanPed,
            s-FlgSit,
            pClfCli,     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            OUTPUT f-FleteUnitario,
            OUTPUT pMensaje
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
    WHEN NO  THEN DO:
        CASE TRUE:
            WHEN s-TpoPed = "CREDMAY" THEN DO:
                RUN pri/PrecioVentaMayorCredito.p (
                    s-TpoPed,
                    s-CodDiv,
                    s-CodCli,
                    s-CodMon,
                    INPUT-OUTPUT s-UndVta,
                    OUTPUT f-Factor,
                    s-CodMat,
                    s-FmaPgo,
                    x-CanPed,
                    s-NroDec,
                    OUTPUT f-PreBas,
                    OUTPUT f-PreVta,
                    OUTPUT f-Dsctos,
                    OUTPUT y-Dsctos,
                    OUTPUT z-Dsctos,
                    OUTPUT x-TipDto,
                    pClfCli,     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */
                    OUTPUT f-FleteUnitario,
                    s-TipVta,
                    pError
                    ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
            END.
            WHEN s-TpoPed = "CONTMAY" THEN DO:
                RUN pri/PrecioVentaMayorContado (s-CodCia,
                                               s-CodDiv,
                                               s-CodCli,
                                               s-CodMon,
                                               s-TpoCmb,
                                               OUTPUT f-Factor,
                                               s-CodMat,
                                               s-FlgSit,
                                               s-UndVta,
                                               x-CanPed,
                                               s-NroDec,
                                               pCodAlm,
                                               OUTPUT f-PreBas,
                                               OUTPUT f-PreVta,
                                               OUTPUT f-Dsctos,
                                               OUTPUT y-Dsctos,
                                               OUTPUT x-TipDto,
                                               OUTPUT f-FleteUnitario
                                           ).
                IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
            END.
            WHEN s-TpoPed = "MIN" THEN DO:
                RUN pri/PrecioVentaMinoristaContado.p (
                                               s-CodDiv,
                                               s-CodMon,
                                               s-TpoCmb,
                                               OUTPUT s-UndVta,
                                               OUTPUT f-Factor,
                                               s-CodMat,
                                               x-CanPed,
                                               s-NroDec,
                                               s-flgsit,       /* s-codbko, */
                                               s-codbco,
                                               s-tarjeta,
                                               s-codpro,
                                               s-NroVale,
                                               OUTPUT f-PreBas,
                                               OUTPUT f-PreVta,
                                           OUTPUT f-Dsctos,
                                           OUTPUT y-Dsctos,
                                           OUTPUT z-Dsctos,
                                           OUTPUT x-TipDto ).
                IF RETURN-VALUE = "ADM-ERROR" THEN RETURN 'ADM-ERROR'.
            END.
        END CASE.
    END.
END CASE.

RETURN 'OK'.

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
         HEIGHT             = 4.19
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


