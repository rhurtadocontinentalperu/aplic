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
         HEIGHT             = 5.88
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* NOTA:
    Se van a genera 2 cotizaciones.
    La primera solo con las familias 001, 002 y 005
    La segunda con el resto de familias 
*/
    
DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pNroPed AS CHAR.
DEF INPUT PARAMETER pUserID AS CHAR.

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
DEFINE VARIABLE X-TIPDTO AS CHAR NO-UNDO.

DEFINE VAR x-NroItem AS INT INIT 1.

/* Creamos un temporal de trabajo */
DEF TEMP-TABLE ITEM LIKE Vtaddocu.

FOR EACH Vtaddocu OF Vtacdocu NO-LOCK:
    CREATE ITEM.
    BUFFER-COPY Vtaddocu TO ITEM.
END.


ASSIGN pNroPed = "".    /* <<< OJO <<< */
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

    /* 1ra pasada: familias 001 002 y 005 */
    RUN Crea-Cabecera-1.

    /* 2da pasa: el resto de familias */
    FIND FIRST ITEM NO-LOCK NO-ERROR.
    IF AVAILABLE ITEM THEN DO:
        RUN Crea-Cabecera-2.
    END.

END.
RELEASE Vtacdocu.
RELEASE FacCorre.
RELEASE Faccpedi.
RELEASE Facdpedi.

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Crea-Cabecera-1) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Cabecera-1 Procedure 
PROCEDURE Crea-Cabecera-1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = ""
        FacCPedi.Atencion = VtaCDocu.DniCli
        FacCPedi.CodRef = VtaCDocu.CodPed
        FacCPedi.NroRef = VtaCDocu.NroPed
        FacCPedi.FlgEst = "W".      /* POR CERRAR */
    /* OJO -> Campo Libre_c01 tiene el ROWID de ExpTarea */
    FIND ExpTarea WHERE ROWID(ExpTarea) = TO-ROWID(FacCPedi.Libre_c01) NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTarea 
        THEN ASSIGN
                FacCPedi.Libre_c02 = ExpTarea.Libre_c01     /* ROWID de ExpTurno */
                FacCPedi.Libre_d01 = ExpTarea.NroDig.       /* Secuencia de ExpTurno */
    /* ************************************************* */
    ASSIGN
        pNroPed = FacCPedi.NroPed
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
       FacCPedi.Hora = STRING(TIME,"HH:MM")
       FacCPedi.Usuario = pUserID
        x-NroItem = 1.  /* <<< OJO <<< */

    RUN Crea-Detalle-Terceros.
    
    /* veamos si ha generado aunque sea 1 item */
    FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Facdpedi THEN DO:
        /* hay que cargarle el resto */
        RUN Crea-Detalle-Resto.
    END.
    {vta/graba-totales.i}

    ASSIGN
        Vtacdocu.CodRef = Faccpedi.CodDoc
        Vtacdocu.NroRef = Faccpedi.NroPed
        Vtacdocu.FlgSit = "T".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Crea-Cabecera-2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Cabecera-2 Procedure 
PROCEDURE Crea-Cabecera-2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    CREATE Faccpedi.
    BUFFER-COPY Vtacdocu TO Faccpedi
        ASSIGN 
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = ""
        FacCPedi.Atencion = VtaCDocu.DniCli
        FacCPedi.CodRef = VtaCDocu.CodPed
        FacCPedi.NroRef = VtaCDocu.NroPed
        FacCPedi.FlgEst = "W".      /* POR CERRAR */
    /* OJO -> Campo Libre_c01 tiene el ROWID de ExpTarea */
    FIND ExpTarea WHERE ROWID(ExpTarea) = TO-ROWID(FacCPedi.Libre_c01) NO-LOCK NO-ERROR.
    IF AVAILABLE ExpTarea 
        THEN ASSIGN
                FacCPedi.Libre_c02 = ExpTarea.Libre_c01     /* ROWID de ExpTurno */
                FacCPedi.Libre_d01 = ExpTarea.NroDig.       /* Secuencia de ExpTurno */
    /* ************************************************* */
    ASSIGN
        pNroPed = pNroPed + ', ' + FacCPedi.NroPed
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
       FacCPedi.Hora = STRING(TIME,"HH:MM")
       FacCPedi.Usuario = pUserID
        x-NroItem = 1.      /* <<< OJO <<< */

    RUN Crea-Detalle-Resto.
    
    {vta/graba-totales.i}

    ASSIGN
        Vtacdocu.CodRef = Faccpedi.CodDoc
        Vtacdocu.NroRef = Faccpedi.NroPed
        Vtacdocu.FlgSit = "T".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Crea-Detalle-Resto) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Detalle-Resto Procedure 
PROCEDURE Crea-Detalle-Resto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
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
                                      OUTPUT z-Dsctos,
                                      OUTPUT x-TipDto
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

        Facdpedi.NroItm = x-NroItem.
        x-NroItem = x-NroItem + 1.

        DELETE ITEM.        /* <<< OJO <<< */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Crea-Detalle-Terceros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Detalle-Terceros Procedure 
PROCEDURE Crea-Detalle-Terceros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK WHERE LOOKUP(Almmmatg.codfam, '001,002,005') > 0:
        CREATE Facdpedi.
        BUFFER-COPY ITEM TO Facdpedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst.
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
                                      OUTPUT z-Dsctos,
                                      OUTPUT x-TipDto
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

        Facdpedi.NroItm = x-NroItem.
        x-NroItem = x-NroItem + 1.

        DELETE ITEM.        /* <<< OJO <<< */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

