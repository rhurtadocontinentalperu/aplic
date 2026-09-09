&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : Validacion de la Cotizacion
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

    DEFINE VARIABLE F-TOT AS DECIMAL INIT 0 NO-UNDO.
    DEFINE VARIABLE F-BOL AS DECIMAL INIT 0 NO-UNDO.
    FOR EACH T-DDOCU NO-LOCK:
        F-Tot = F-Tot + T-DDOCU.ImpLin.
    END.
    IF F-Tot = 0 THEN DO:
       MESSAGE "** Importe total debe ser mayor a cero **" VIEW-AS ALERT-BOX ERROR.
       RETURN "ADM-ERROR".   
    END.
    /* RHC 20.09.05 Transferencia gratuita */
    IF VtaCDocu.FmaPgo:SCREEN-VALUE = '900' AND VtaCDocu.NroCar:SCREEN-VALUE <> '' THEN DO:
        MESSAGE 'En caso de transferencia gratuita NO es válido el Nº de Tarjeta' 
            VIEW-AS ALERT-BOX WARNING.
        RETURN 'ADM-ERROR'.
    END.
    /* IMPORTE MINIMO */
    DEF VAR pImpMin AS DEC NO-UNDO.

    FOR EACH T-DDOCU NO-LOCK:
        f-Bol = f-Bol + T-DDOCU.ImpLin.
    END.
    IF s-codmon = 2 THEN f-Bol = f-Bol * s-TpoCmb.
    RUN gn/pMinCotPed (s-CodCia,
                       s-CodDiv,
                       s-CodPed,
                       OUTPUT pImpMin).
    IF pImpMin > 0 AND f-Bol < pImpMin THEN DO:
        MESSAGE 'El importe mínimo para COTIZACIONES es de S/.' pImpMin SKIP
            'Solo ha cotizacion S/.' f-Bol
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


