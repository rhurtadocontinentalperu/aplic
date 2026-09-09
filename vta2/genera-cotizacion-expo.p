&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     : Generar cotizaciones

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF OUTPUT PARAMETER pNroPed AS CHAR.

DEFINE SHARED VAR s-user-id AS CHAR.
DEFINE SHARED VAR s-codcia AS INT.
DEFINE SHARED VAR s-coddiv AS CHAR.

DEF VAR s-coddoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.
DEF VAR s-nroser AS INT NO-UNDO.
DEF VAR s-tpoped AS CHAR NO-UNDO.
DEF VAR s-codmon LIKE faccpedi.codmon NO-UNDO.
DEF VAR s-nrodec AS INT NO-UNDO.
DEF VAR s-tpocmb AS DEC NO-UNDO.
DEF VAR s-porigv AS DEC NO-UNDO.

DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.       /* DESCUENTO EXPOLIBRERIA */
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK NO-ERROR.

IF NOT AVAILABLE Vtacdocu THEN DO:
    MESSAGE 'No se encontró la pre-cotización' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

FIND FIRST FacCorre WHERE Faccorre.codcia = s-codcia
    AND Faccorre.coddiv = s-coddiv
    AND Faccorre.coddoc = s-coddoc
    AND  FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    MESSAGE 'NO está configurado el correlativo para el doc.' s-coddoc
        VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-NroSer = FacCorre.NroSer.

DEF TEMP-TABLE ResumenxLinea
    FIELD codmat LIKE almmmatg.codmat
    FIELD codfam LIKE almmmatg.codfam
    FIELD subfam LIKE almmmatg.subfam
    FIELD canped LIKE facdpedi.canped
    INDEX Llave01 AS PRIMARY /*UNIQUE*/ codmat codfam subfam.

DEF TEMP-TABLE ErroresxLinea LIKE ResumenxLinea.

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
         HEIGHT             = 5.12
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE "No se pudo bloquear la pre-cotización" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = VtaCDocu.Libre_c02
        FacCPedi.Atencion = VtaCDocu.DniCli
        FacCPedi.Libre_d02 = VtaCDocu.PesMat.
    ASSIGN
        pNroPed = FacCPedi.NroPed
        s-TpoPed = FacCPedi.TpoPed
        s-CodMon = FacCPedi.CodMon
        s-NroDec = FacCPedi.Libre_d01
        s-TpoCmb = FacCPedi.TpoCmb
        s-PorIgv = FacCPedi.PorIgv
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
       FacCPedi.Hora = STRING(TIME,"HH:MM")
       FacCPedi.Usuario = S-USER-ID.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK, FIRST Almmmatg OF Vtaddocu NO-LOCK
        BY VtaDDocu.NroItm:
        CREATE Facdpedi.
        BUFFER-COPY Vtaddocu TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
/*         RUN vta2/PrecioMayorista-Cred-01 ( */
/*             Faccpedi.TpoPed,               */
/*             Faccpedi.CodDiv,               */
/*             Faccpedi.CodCli,               */
/*             Faccpedi.CodMon,               */
/*             INPUT-OUTPUT s-UndVta,         */
/*             OUTPUT f-Factor,               */
/*             Facdpedi.codmat,               */
/*             Faccpedi.fmapgo,               */
/*             Facdpedi.CanPed,               */
/*             4,                             */
/*             OUTPUT f-PreBas,               */
/*             OUTPUT f-PreVta,               */
/*             OUTPUT f-Dsctos,               */
/*             OUTPUT y-Dsctos,               */
/*             OUTPUT z-Dsctos,               */
/*             OUTPUT x-TipDto,               */
/*             FALSE                          */
/*             ).                             */
        RUN vta2/PrecioListaxMayorCredito (
            Faccpedi.TpoPed,
            pCodDiv,
            Faccpedi.CodCli,
            Faccpedi.CodMon,
            INPUT-OUTPUT s-UndVta,
            OUTPUT f-Factor,
            Facdpedi.CodMat,
            Faccpedi.fmapgo,
            Facdpedi.CanPed,
            4,
            OUTPUT f-PreBas,
            OUTPUT f-PreVta,
            OUTPUT f-Dsctos,
            OUTPUT y-Dsctos,
            OUTPUT z-Dsctos,
            OUTPUT x-TipDto,
            "",
            FALSE
            ).

        ASSIGN
            Facdpedi.UndVta = s-UndVta
            Facdpedi.Factor = f-Factor
            Facdpedi.PorDto = f-Dsctos
            Facdpedi.PorDto2 = 0
            Facdpedi.PreUni = f-PreVta
            Facdpedi.PreBas = f-PreBas
            Facdpedi.Por_Dsctos[1] = 0
            Facdpedi.Por_DSCTOS[2] = z-Dsctos
            Facdpedi.Por_Dsctos[3] = Y-DSCTOS
            Facdpedi.Libre_c04 = X-TIPDTO.
        ASSIGN
            Facdpedi.ImpLin = Facdpedi.CanPed * Facdpedi.PreUni * 
                          ( 1 - Facdpedi.Por_Dsctos[1] / 100 ) *
                          ( 1 - Facdpedi.Por_Dsctos[2] / 100 ) *
                          ( 1 - Facdpedi.Por_Dsctos[3] / 100 ).
        IF Facdpedi.Por_Dsctos[1] = 0 AND Facdpedi.Por_Dsctos[2] = 0 AND Facdpedi.Por_Dsctos[3] = 0 
            THEN Facdpedi.ImpDto = 0.
            ELSE Facdpedi.ImpDto = Facdpedi.CanPed * Facdpedi.PreUni - Facdpedi.ImpLin.
        ASSIGN
            Facdpedi.ImpLin = ROUND(Facdpedi.ImpLin, 2)
            Facdpedi.ImpDto = ROUND(Facdpedi.ImpDto, 2).
        ASSIGN 
            Facdpedi.AftIgv = Almmmatg.AftIgv
            Facdpedi.AftIsc = Almmmatg.AftIsc.
        IF Facdpedi.AftIsc THEN Facdpedi.ImpIsc = ROUND(Facdpedi.PreBas * Facdpedi.CanPed * (Almmmatg.PorIsc / 100),4).
        IF Facdpedi.AftIgv THEN  Facdpedi.ImpIgv = Facdpedi.ImpLin - ROUND(Facdpedi.ImpLin  / (1 + (FacCPedi.PorIgv / 100)),4).
    END.

    /* RHC 07/11/2013 DESCUENTOS ESPECIALES POR VOLUMEN DE VENTAS */
    RUN Descuentos-Finales-01.
    RUN Descuentos-Finales-02.
    /* ********************************************************** */

    {vta2/graba-totales-cotizacion-cred.i}

    /* Referencias cruzadas */
    ASSIGN
        VtaCDocu.CodRef = FacCPedi.CodDoc
        VtaCDocu.NroRef = FacCPedi.NroPed
        FacCPedi.CodRef = VtaCDocu.CodPed
        FacCPedi.NroRef = VtaCDocu.NroPed
        Vtacdocu.FlgSit = "T".
    /* ******************** */
END.
RELEASE Vtacdocu.
RELEASE FacCorre.
RELEASE Faccpedi.
RELEASE Facdpedi.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Descuentos-Finales-01) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-01 Procedure 
PROCEDURE Descuentos-Finales-01 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxlinearesumida.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Descuentos-Finales-02) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Descuentos-Finales-02 Procedure 
PROCEDURE Descuentos-Finales-02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/descuentoxvolumenxsaldosresumida.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

