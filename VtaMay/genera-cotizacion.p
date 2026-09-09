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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pNroPed AS CHAR.

DEFINE SHARED VAR s-user-id AS CHAR.

FIND Vtacdocu WHERE ROWID(Vtacdocu) = pRowid NO-LOCK NO-ERROR.

IF NOT AVAILABLE Vtacdocu THEN DO:
    MESSAGE 'No se encontró la pre-cotización' VIEW-AS ALERT-BOX ERROR.
    RETURN "ADM-ERROR".
END.

DEF VAR s-coddoc AS CHAR INIT "COT" NO-UNDO.
DEF VAR s-UndVta AS CHAR NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

DEFINE VARIABLE F-PREBAS LIKE Almmmatg.PreBas NO-UNDO.
DEFINE VARIABLE F-DSCTOS LIKE Almmmatg.PorMax NO-UNDO.
DEFINE VARIABLE F-PREVTA AS DECI NO-UNDO.
DEFINE VARIABLE Y-DSCTOS AS DECI NO-UNDO.
DEFINE VARIABLE Z-DSCTOS AS DECI NO-UNDO.       /* DESCUENTO EXPOLIBRERIA */

DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND CURRENT Vtacdocu EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Vtacdocu THEN DO:
        MESSAGE "No se pudo bloquear la pre-cotización" VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.
    FIND FacCorre WHERE FacCorre.CodCia = Vtacdocu.codcia
        AND FacCorre.CodDoc = S-CODDOC 
        AND FacCorre.CodDiv = Vtacdocu.coddiv
        AND Faccorre.Codalm = Vtacdocu.codalm
        EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE FacCorre THEN DO:
        MESSAGE "No se pudo bloquear el control de correlativos" VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = ""
        FacCPedi.Atencion = VtaCDocu.DniCli.
    ASSIGN
        pNroPed = FacCPedi.NroPed
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
       FacCPedi.Hora = STRING(TIME,"HH:MM")
       FacCPedi.Usuario = S-USER-ID.
    FOR EACH Vtaddocu OF Vtacdocu NO-LOCK, FIRST Almmmatg OF Vtaddocu NO-LOCK:
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

        /***RD01 -  Precios
        RUN vtagn/PrecioListaMayorista-1 (
                                      Faccpedi.CodDiv,
                                      Faccpedi.CodCli,
                                      Faccpedi.CodMon,
                                      Faccpedi.TpoCmb,
                                      OUTPUT s-UndVta,
                                      OUTPUT f-Factor,
                                      Facdpedi.CodMat,
                                      Faccpedi.FmaPgo,
                                      Facdpedi.CanPed,
                                      4,
                                      OUTPUT f-PreBas,
                                      OUTPUT f-PreVta,
                                      OUTPUT f-Dsctos,
                                      OUTPUT y-Dsctos,
                                      OUTPUT z-Dsctos).
        ************/     

        RUN vtamay/PrecioVenta-3 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodCli,
                            Faccpedi.CodMon,
                            Faccpedi.TpoCmb,
                            Facdpedi.factor,
                            Facdpedi.CodMat,
                            Faccpedi.FmaPgo,
                            Facdpedi.CanPed,
                            4,
                            OUTPUT f-PreBas,
                            OUTPUT f-PreVta,
                            OUTPUT f-Dsctos,
                            OUTPUT y-Dsctos).

        ASSIGN
            Facdpedi.UndVta = s-UndVta
            Facdpedi.Factor = f-Factor
            Facdpedi.PorDto = f-Dsctos
            Facdpedi.PorDto2 = 0
            Facdpedi.PreUni = f-PreVta
            Facdpedi.PreBas = f-PreBas
            Facdpedi.Por_Dsctos[1] = 0
            Facdpedi.Por_DSCTOS[2] = z-Dsctos
            Facdpedi.Por_Dsctos[3] = Y-DSCTOS.
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
    {vta/graba-totales.i}
    ASSIGN
        Vtacdocu.FlgSit = "T".
END.
RELEASE Vtacdocu.
RELEASE FacCorre.
RELEASE Faccpedi.
RELEASE Facdpedi.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


