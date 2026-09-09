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
DEF INPUT PARAMETER pCodDiv AS CHAR.    /* Lista de Precios */
DEF INPUT PARAMETER S-CODCLI AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT-OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.       /* Default 1 */
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER s-FmaPgo AS CHAR.       /* Condicion de venta */     
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER s-NroDec AS INT.
DEF OUTPUT PARAMETER F-PREBAS AS DEC DECIMALS 4.
DEF OUTPUT PARAMETER F-PREVTA AS DEC DECIMALS 4.    /* Precio - Dscto CondVta - ClasfCliente */
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.       /* Descuento incluido en el precio unitario base */
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.       /* Descuento por Volumen y/o Promocional */
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.       /* Descuento por evento */
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.      /* Tipo de descuento aplicado (PROM, VOL) */ 
/* Se anula este parámetro por compatibilidad  */
DEF INPUT PARAMETER pClfCli AS CHAR.        /* SOlo si tiene un valor me sirve */
/* */
DEF OUTPUT PARAMETER f-FleteUnitario AS DEC.
DEF INPUT  PARAMETER s-TipVta AS CHAR.      /* Lista "A" o "B" (SOLO POR COMPATIBILIDAD) */
DEF INPUT PARAMETER pError AS LOG.          /* Mostrar el error en pantalla */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.

/* 31/05/2024: El control de PELDAÑO se va a hacer en el PRICING */
/* => Siempre se va a ejecutar la rutina  pri/PrecioVentaMayorCreditoFlash.p */
DEF VAR LogParteEscalera AS LOG INIT YES NO-UNDO.   /* Por defecto SI pertenece a la escalera de precios */
/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
/* DEFINE VAR hProc AS HANDLE NO-UNDO.                                   */
/*                                                                       */
/* RUN web/web-library.p PERSISTENT SET hProc.                           */
/* RUN web_api-captura-peldano-valido IN hProc (INPUT pCodDiv,           */
/*                                              OUTPUT LogParteEscalera, */
/*                                              OUTPUT pMensaje).        */
/* DELETE PROCEDURE hProc.                                               */
/* IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                */
/*     MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.                         */
/*     RETURN 'ADM-ERROR'.                                               */
/* END.                                                                  */
/* *************************************************************************************** */
CASE LogParteEscalera:
    WHEN YES THEN DO:
        RUN pri/unit-price-credit-sale.p (
            INPUT s-TpoPed,
            INPUT pCodDiv,
            INPUT s-CodCli,
            INPUT s-FmaPgo,
            INPUT s-CodMon,
            INPUT s-NroDec,
            INPUT s-CodMat,
            INPUT-OUTPUT s-UndVta,
            INPUT x-CanPed,
            INPUT "",

            OUTPUT f-Factor,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            OUTPUT f-FleteUnitario,
            OUTPUT pMensaje
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
    END.
/*     WHEN YES THEN DO:                                                                          */
/*         /*RUN pri/PrecioVentaMayorCreditoFlash.p (*/                                           */
/*         RUN pri/pri-precio-mayorista-credito.p (                                               */
/*             s-TpoPed,                                                                          */
/*             pCodDiv,                                                                           */
/*             s-CodCli,                                                                          */
/*             s-CodMon,                                                                          */
/*             INPUT-OUTPUT s-UndVta,                                                             */
/*             OUTPUT f-Factor,                                                                   */
/*             s-CodMat,                                                                          */
/*             s-FmaPgo,                                                                          */
/*             x-CanPed,                                                                          */
/*             s-NroDec,                                                                          */
/*             OUTPUT f-PreBas,                                                                   */
/*             OUTPUT f-PreVta,                                                                   */
/*             OUTPUT f-Dsctos,                                                                   */
/*             OUTPUT y-Dsctos,                                                                   */
/*             OUTPUT z-Dsctos,                                                                   */
/*             OUTPUT x-TipDto,                                                                   */
/*             pClfCli,     /* ClfCli: lo ingresamos solo si se quiere forzar la clasificacion */ */
/*             OUTPUT f-FleteUnitario,                                                            */
/*             s-TipVta,                                                                          */
/*             OUTPUT pMensaje                                                                    */
/*             ).                                                                                 */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.                                 */
/*     END.                                                                                       */
    WHEN NO  THEN DO:
        RUN pri/PrecioVentaMayorCredito.p (
            s-TpoPed,
            pCodDiv,
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
        /*
        MESSAGE "NOOO Escalera" SKIP
                "s-CodMat " s-CodMat SKIP
                "s-CodCli " s-CodCli SKIP
                "pCodDiv " pCodDiv SKIP
                "x-CanPed " x-CanPed SKIP
                "f-PreBas " f-PreBas SKIP
                "f-PreVta " f-PreVta SKIP
                "pClfCli " pClfCli SKIP
                "f-Dsctos " f-Dsctos SKIP
                "y-Dsctos " y-Dsctos SKIP
                "z-Dsctos " z-Dsctos SKIP
                "x-TipDto " x-TipDto SKIP
                "pError " pError.
        */
        IF RETURN-VALUE = 'ADM-ERROR' THEN RETURN 'ADM-ERROR'.
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
         HEIGHT             = 4.15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


