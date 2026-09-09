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

TRIGGER PROCEDURE FOR WRITE OF VtaListaMinGn OLD BUFFER OldVtaListaMinGn.

DEFINE SHARED VAR s-CodCia AS INT.

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
         HEIGHT             = 6.58
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* RHC 04/03/2019 Log General */
/*{TRIGGERS/i-logtransactions.i &TableName="vtalistamingn" &Event="WRITE"}*/

/* ************************************************************************************** */
/* RHC 22/08/19 NUEVAS TABLAS */
/* ************************************************************************************** */
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pRCID AS INT.

DEF VAR f-PrecioLista AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR s-CanalVenta AS CHAR.

FIND Almmmatg OF VtaListaMinGn NO-LOCK NO-ERROR.

DEF VAR pError AS CHAR NO-UNDO.
RUN MIN_Actualiza-Descuentos (OUTPUT pError).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    pError = 'ERROR al actualizar los descuentos en listas de precios minorista' + CHR(10) + pError.
    MESSAGE pError VIEW-AS ALERT-BOX ERROR.
    UNDO, RETURN ERROR.
END.
/* ************************************************************************************** */
/* RHC 21/10/2021 Grabar importe sin igv */
/* ************************************************************************************** */
FIND FIRST Sunat_Fact_Electr_Taxs  WHERE Sunat_Fact_Electr_Taxs.TaxTypeCode = "IGV"
    AND Sunat_Fact_Electr_Taxs.Disabled = NO
    AND TODAY >= Sunat_Fact_Electr_Taxs.Start_Date 
    AND TODAY <= Sunat_Fact_Electr_Taxs.End_Date 
    AND Sunat_Fact_Electr_Taxs.Tax > 0
    NO-LOCK NO-ERROR.
IF AVAILABLE Sunat_Fact_Electr_Taxs THEN DO:
    RUN MIN_Importe-sin-igv.
END.
/* ************************************************************************************** */
/* ************************************************************************************** */
DEF VAR x-CtoTot AS DEC NO-UNDO.
DEF VAR f-Factor AS DEC NO-UNDO.

DEF VAR x-PreNew LIKE VtaListaMinGn.PreOfi NO-UNDO.
DEF VAR x-PreOld LIKE VtaListaMinGn.PreOfi NO-UNDO.
DEF VAR pEstado AS CHAR NO-UNDO.
ASSIGN
    x-PreNew = VtaListaMinGn.PreOfi
    x-PreOld = OldVtaListaMinGn.PreOfi.
IF VtaListaMinGn.MonVta = 2 THEN
    ASSIGN
    x-PreNew = x-PreNew * VtaListaMinGn.TpoCmb
    x-PreOld = x-PreOld * VtaListaMinGn.TpoCmb.
RUN gn/p-ecommerce (INPUT "aplic/gn/p-ecommerce-precios.p",
                    INPUT STRING(s-CodCia) + ',' +
                    VtaListaMinGn.CodMat + ',' +
                    STRING(x-PreNew) + ',' +
                    STRING(x-PreOld) + ',' +
                    "U" + ',' +
                    STRING(VtaListaMinGn.TpoCmb) + ',' +
                    STRING(VtaListaMinGn.MonVta) + ',' +
                    s-User-Id,
                    OUTPUT pEstado).

IF OldVtaListaMinGn.codmat <> '' THEN DO:
    IF VtaListaMinGn.CHR__01 <>  OldVtaListaMinGn.CHR__01
        OR VtaListaMinGn.MonVta <>  OldVtaListaMinGn.MonVta
        OR VtaListaMinGn.PreOfi <> OldVtaListaMinGn.PreOfi
        OR VtaListaMinGn.TpoCmb <> OldVtaListaMinGn.TpoCmb
        OR VtaListaMinGn.DtoVolD[1] <> OldVtaListaMinGn.DtoVolD[1] 
        OR VtaListaMinGn.DtoVolD[2] <> OldVtaListaMinGn.DtoVolD[2]  
        OR VtaListaMinGn.DtoVolD[3] <> OldVtaListaMinGn.DtoVolD[3] 
        OR VtaListaMinGn.DtoVolD[4] <> OldVtaListaMinGn.DtoVolD[4] 
        OR VtaListaMinGn.DtoVolD[5] <> OldVtaListaMinGn.DtoVolD[5] 
        OR VtaListaMinGn.DtoVolD[6] <> OldVtaListaMinGn.DtoVolD[6] 
        OR VtaListaMinGn.DtoVolD[7] <> OldVtaListaMinGn.DtoVolD[7] 
        OR VtaListaMinGn.DtoVolD[8] <> OldVtaListaMinGn.DtoVolD[8] 
        OR VtaListaMinGn.DtoVolD[9] <> OldVtaListaMinGn.DtoVolD[9] 
        OR VtaListaMinGn.DtoVolD[10] <> OldVtaListaMinGn.DtoVolD[10] 
        OR VtaListaMinGn.DtoVolR[1] <> OldVtaListaMinGn.DtoVolR[1] 
        OR VtaListaMinGn.DtoVolR[2] <> OldVtaListaMinGn.DtoVolR[2]
        OR VtaListaMinGn.DtoVolR[3] <> OldVtaListaMinGn.DtoVolR[3]
        OR VtaListaMinGn.DtoVolR[4] <> OldVtaListaMinGn.DtoVolR[4]
        OR VtaListaMinGn.DtoVolR[5] <> OldVtaListaMinGn.DtoVolR[5]
        OR VtaListaMinGn.DtoVolR[6] <> OldVtaListaMinGn.DtoVolR[6]
        OR VtaListaMinGn.DtoVolR[7] <> OldVtaListaMinGn.DtoVolR[7]
        OR VtaListaMinGn.DtoVolR[8] <> OldVtaListaMinGn.DtoVolR[8]
        OR VtaListaMinGn.DtoVolR[9] <> OldVtaListaMinGn.DtoVolR[9]
        OR VtaListaMinGn.DtoVolR[10] <> OldVtaListaMinGn.DtoVolR[10] 
        THEN DO:
        /* LOG de control */
        CREATE LogListaMinGn.
        BUFFER-COPY VtaListaMinGn TO LogListaMinGn
            ASSIGN
                LogListaMinGn.NumId = pRCID
                LogListaMinGn.LogDate = TODAY
                LogListaMinGn.LogTime = STRING(TIME, 'HH:MM:SS')
                LogListaMinGn.LogUser = s-user-id
                LogListaMinGn.FlagFechaHora = DATETIME(TODAY, MTIME)
                LogListaMinGn.FlagUsuario = s-user-id
                LogListaMinGn.FlagEstado = "U".
    END.
END.
ELSE DO:
    /* LOG de control */
    CREATE LogListaMinGn.
    BUFFER-COPY VtaListaMinGn TO LogListaMinGn
        ASSIGN
            LogListaMinGn.NumId = pRCID
            LogListaMinGn.LogDate = TODAY
            LogListaMinGn.LogTime = STRING(TIME, 'HH:MM:SS')
            LogListaMinGn.LogUser = s-user-id
            LogListaMinGn.FlagFechaHora = DATETIME(TODAY, MTIME)
            LogListaMinGn.FlagUsuario = s-user-id
            LogListaMinGn.FlagEstado = "I".
END.

/* RHC 28/06/2017 Solicitado por Martin Salcedo */
ASSIGN
    VtaListaMinGn.DateUpdate = TODAY
    VtaListaMinGn.HourUpdate = STRING(TIME,'HH:MM:SS')
    VtaListaMinGn.UserUpdate = s-user-id.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-MIN_Actualiza-Descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MIN_Actualiza-Descuentos Procedure 
PROCEDURE MIN_Actualiza-Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

DEF BUFFER b-VtaDctoPromMin FOR VtaDctoPromMin.
DEF VAR LocalCuentaBloqueos AS INTE NO-UNDO.
DEF VAR LocalCuentaErrores AS INTE NO-UNDO.

IF (VtaListaMinGn.PreOfi <> OldVtaListaMinGn.PreOfi) AND AVAILABLE Almmmatg THEN DO:
    ASSIGN
        s-CanalVenta = 'MIN'.   /* Lista de Precios UTILEX */
    f-PrecioLista = VtaListaMinGn.PreOfi.
    /* Actualizamos VtaDctoPromMin: Promociones Vigentes */
    FOR EACH VtaDctoPromMin NO-LOCK WHERE VtaDctoPromMin.CodCia = VtaListaMinGn.CodCia 
        AND VtaDctoPromMin.CodMat = VtaListaMinGn.CodMat 
        AND (TODAY >= VtaDctoPromMin.FchIni AND TODAY <= VtaDctoPromMin.FchFin):
        LocalCuentaBloqueos = 0.
        REPEAT:
            FIND FIRST b-VtaDctoPromMin WHERE ROWID(b-VtaDctoPromMin) = ROWID(VtaDctoPromMin) 
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-VtaDctoPromMin THEN LEAVE.
            LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
            IF LocalCuentaBloqueos > 1000 THEN DO:
                {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        ASSIGN
            b-VtaDctoPromMin.Precio = ROUND(f-PrecioLista * (1 - (b-VtaDctoPromMin.Descuento  / 100)), 4).
    END.
    /* Actualizamos VtaDctoPromMin: Promociones Proyectadas */
    FOR EACH VtaDctoPromMin EXCLUSIVE-LOCK WHERE VtaDctoPromMin.CodCia = VtaListaMinGn.CodCia 
        AND VtaDctoPromMin.CodMat = VtaListaMinGn.CodMat 
        AND VtaDctoPromMin.FchIni > TODAY:
        LocalCuentaBloqueos = 0.
        REPEAT:
            FIND FIRST b-VtaDctoPromMin WHERE ROWID(b-VtaDctoPromMin) = ROWID(VtaDctoPromMin) 
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-VtaDctoPromMin THEN LEAVE.
            LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
            IF LocalCuentaBloqueos > 1000 THEN DO:
                {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        ASSIGN
            b-VtaDctoPromMin.Precio = ROUND(f-PrecioLista * (1 - (b-VtaDctoPromMin.Descuento  / 100)), 4).
    END.
    /* Actualizamos Precio por Volumen */
    DO x-Item = 1 TO 10:
        IF VtaListaMinGn.DtoVolD[x-Item] <> 0 THEN
            ASSIGN VtaListaMinGn.DtoVolP[x-Item] = ROUND(f-PrecioLista * (1 - (VtaListaMinGn.DtoVolD[x-Item]  / 100)), 4).
    END.
END.
IF AVAILABLE(b-VtaDctoPromMin) THEN RELEASE b-VtaDctoPromMin.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-MIN_Importe-sin-igv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MIN_Importe-sin-igv Procedure 
PROCEDURE MIN_Importe-sin-igv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR k AS INTE NO-UNDO.

IF VtaListaMinGn.PreOfi <> OLDVtaListaMinGn.PreOfi THEN DO:
    ASSIGN
        VtaListaMinGn.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        VtaListaMinGn.ImporteUnitarioSinImpuesto = ROUND(VtaListaMinGn.PreOfi / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        VtaListaMinGn.ImporteUnitarioImpuesto = VtaListaMinGn.PreOfi - VtaListaMinGn.ImporteUnitarioSinImpuesto
        .
END.
DO k = 1 TO 10:
    IF VtaListaMinGn.DtoVolP[k] <> OLDVtaListaMinGn.DtoVolP[k] THEN 
        ASSIGN
        VtaListaMinGn.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        VtaListaMinGn.DtoVolPSinImpuesto[k] = ROUND(VtaListaMinGn.DtoVolP[k] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        VtaListaMinGn.DtoVolPImpuesto[k] = VtaListaMinGn.DtoVolP[k] - VtaListaMinGn.DtoVolPSinImpuesto[k]
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

