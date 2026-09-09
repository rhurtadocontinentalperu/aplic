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

DEF INPUT PARAMETER S-CODDIV AS CHAR.
DEF INPUT PARAMETER S-CODMON AS INT.
DEF INPUT PARAMETER S-TPOCMB AS DEC.
DEF OUTPUT PARAMETER S-UNDVTA AS CHAR.
DEF OUTPUT PARAMETER f-Factor AS DEC.
DEF INPUT PARAMETER S-CODMAT AS CHAR.
DEF INPUT PARAMETER X-CANPED AS DEC.
DEF INPUT PARAMETER x-NroDec AS INT.
DEF INPUT PARAMETER s-FlgSit AS CHAR.
DEF INPUT PARAMETER s-CodBco AS CHAR.
DEF INPUT PARAMETER s-Tarjeta AS CHAR.
DEF INPUT PARAMETER s-CodPro AS CHAR.
DEF INPUT PARAMETER s-NroVale AS CHAR.
DEF OUTPUT PARAMETER F-PREBAS AS DEC.
DEF OUTPUT PARAMETER F-PREVTA AS DEC.
DEF OUTPUT PARAMETER F-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Y-DSCTOS AS DEC.
DEF OUTPUT PARAMETER Z-DSCTOS AS DEC.
DEF OUTPUT PARAMETER X-TIPDTO AS CHAR.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-codcia AS INTE.

DEF VAR LogParteEscalera AS LOG INIT YES NO-UNDO.   /* Por defecto SI pertenece a la escalera de precios */

/* 31/05/2024: El control de PELDAÑO se va a hacer en el PRICING */
/* => Siempre se va a ejecutar la rutina  pri/PrecioVentaMinoristaContadoFlash.p */
/* *************************************************************************************** */
/* Capturamos si la división pertenece a un peldaño que es parte de la escalera de precios */
/* *************************************************************************************** */
/* DEFINE VAR hProc AS HANDLE NO-UNDO.                                   */
/*                                                                       */
/* RUN web/web-library.p PERSISTENT SET hProc.                           */
/* RUN web_api-captura-peldano-valido IN hProc (INPUT s-CodDiv,          */
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
        RUN pri/PrecioVentaMinoristaContadoFlash.p (
                                       s-CodDiv,
                                       s-CodMon,
                                       s-TpoCmb,
                                       OUTPUT s-UndVta,
                                       OUTPUT f-Factor,
                                       s-CodMat,
                                       x-CanPed,
                                       x-NroDec,
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
                                       OUTPUT x-TipDto,
                                       OUTPUT pMensaje).
            IF RETURN-VALUE = "ADM-ERROR" THEN DO:
                IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo determinar el precio".
                RETURN 'ADM-ERROR'.
            END.
        END.
        WHEN NO  THEN DO:
            RUN pri/PrecioVentaMinoristaContado.p (
                                           s-CodDiv,
                                           s-CodMon,
                                           s-TpoCmb,
                                           OUTPUT s-UndVta,
                                           OUTPUT f-Factor,
                                           s-CodMat,
                                           x-CanPed,
                                           x-NroDec,
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
         HEIGHT             = 6
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


