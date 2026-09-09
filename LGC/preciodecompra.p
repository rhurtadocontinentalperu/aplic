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
         HEIGHT             = 3.5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF INPUT PARAMETER pCodPro AS CHAR.
DEF INPUT PARAMETER pCodMat AS CHAR.
DEF INPUT PARAMETER pCodMon AS INT.
DEF INPUT PARAMETER pTpoCmb AS DEC.
DEF INPUT PARAMETER pContratoMarco AS LOG.
DEF OUTPUT PARAMETER pDsctos AS DEC EXTENT 3.
DEF OUTPUT PARAMETER pIgvMat AS DEC.
DEF OUTPUT PARAMETER pPreUni AS DEC.
DEF OUTPUT PARAMETER pOk AS LOG.

DEF SHARED VAR s-codcia AS INT.

/***** Se Usara con lista de Precios Proveedor Original *****/
IF pContratoMarco = NO THEN DO:
    FIND lg-dmatpr WHERE lg-dmatpr.codcia = s-codcia
        AND lg-dmatpr.codmat = pCodMat
        AND CAN-FIND(lg-cmatpr WHERE lg-cmatpr.codcia = s-codcia
                     AND lg-cmatpr.nrolis = lg-dmatpr.nrolis
                     AND lg-cmatpr.codpro = pCodPro
                     AND lg-cmatpr.flgest = 'A' NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE LG-dmatpr THEN DO:
        MESSAGE "Código de articulo no esta asignado al proveedor" SKIP
            "desea continuar?" VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO
            UPDATE pOk.
        IF NOT pOk THEN RETURN.
    END.
    IF AVAILABLE LG-dmatpr THEN DO:
        ASSIGN
            pDsctos[1] = LG-dmatpr.Dsctos[1] 
            pDsctos[2] = LG-dmatpr.Dsctos[2] 
            pDsctos[3] = LG-dmatpr.Dsctos[3] 
            pIgvMat = LG-dmatpr.IgvMat.
        IF pCodMon = 1 THEN DO:
            IF LG-dmatpr.CodMon = 1 THEN pPreUni = LG-dmatpr.PreAct.
            ELSE pPreUni = ROUND(LG-dmatpr.PreAct * pTpoCmb,4).
        END.
        ELSE DO:
            IF LG-dmatpr.CodMon = 2 THEN pPreUni = LG-dmatpr.PreAct.
            ELSE pPreUni = ROUND(LG-dmatpr.PreAct / pTpoCmb,4).
        END.
    END.
END.
ELSE DO:
    FIND lg-dlistamarco WHERE lg-dlistamarco.codcia = s-codcia
        AND lg-dlistamarco.codmat = pCodMat
        AND CAN-FIND(lg-clistamarco WHERE lg-clistamarco.codcia = s-codcia
                     AND lg-clistamarco.nrolis = lg-dlistamarco.nrolis
                     AND lg-clistamarco.codpro = pCodPro
                     AND lg-clistamarco.flgest = 'A' NO-LOCK)
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE lg-dlistamarco THEN DO:
        MESSAGE "Código de articulo no esta asignado al proveedor" SKIP
            "desea continuar?" VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO
            UPDATE pOk.
        IF NOT pOk THEN RETURN.
    END.
    IF AVAILABLE lg-dlistamarco THEN DO:
        ASSIGN
            pDsctos[1] = lg-dlistamarco.Dsctos[1] 
            pDsctos[2] = lg-dlistamarco.Dsctos[2] 
            pDsctos[3] = lg-dlistamarco.Dsctos[3] 
            pIgvMat = lg-dlistamarco.IgvMat.
        IF pCodMon = 1 THEN DO:
            IF lg-dlistamarco.CodMon = 1 THEN pPreUni = lg-dlistamarco.PreAct.
            ELSE pPreUni = ROUND(lg-dlistamarco.PreAct * pTpoCmb,4).
        END.
        ELSE DO:
            IF lg-dlistamarco.CodMon = 2 THEN pPreUni = lg-dlistamarco.PreAct.
            ELSE pPreUni = ROUND(lg-dlistamarco.PreAct / pTpoCmb,4).
        END.
    END.
END.
pOk = YES.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


