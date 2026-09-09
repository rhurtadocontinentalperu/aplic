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

TRIGGER PROCEDURE FOR WRITE OF VtaListaMay OLD BUFFER OldVtaListaMay.

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
         HEIGHT             = 5.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* RHC 04/03/2019 Log General */
/*{TRIGGERS/i-logtransactions.i &TableName="vtalistamay" &Event="WRITE"}*/
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR pRCID AS INT.

/* ************************************************************************************** */
/* RHC 22/08/19 NUEVAS TABLAS */
/* ************************************************************************************** */
DEF VAR f-PrecioLista AS DEC NO-UNDO.
DEF VAR x-Item AS INT NO-UNDO.
DEF VAR pError AS CHAR NO-UNDO.

FIND Almmmatg OF VtaListaMay NO-LOCK NO-ERROR.

RUN MAY_Actualiza-Descuentos (OUTPUT pError).
IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
    pError = 'ERROR al actualizar el TC en las listas de precios' + CHR(10) + pError.
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
    RUN MAY_Importe-sin-igv.
END.
/* ************************************************************************************** */

IF VtaListaMay.CodDiv = "00506" THEN DO:
    DEF VAR x-PreNew LIKE VtaListaMay.PreOfi NO-UNDO.
    DEF VAR x-PreOld LIKE VtaListaMay.PreOfi NO-UNDO.
    DEF VAR pEstado AS CHAR NO-UNDO.
    ASSIGN
        x-PreNew = VtaListaMay.PreOfi
        x-PreOld = OldVtaListaMay.PreOfi.
    IF VtaListaMay.MonVta = 2 THEN
        ASSIGN
        x-PreNew = x-PreNew * VtaListaMay.TpoCmb
        x-PreOld = x-PreOld * VtaListaMay.TpoCmb.
    RUN gn/p-ecommerce (INPUT "aplic/gn/p-ecommerce-precios.p",
                        INPUT STRING(s-CodCia) + ',' +
                        VtaListaMay.CodMat + ',' +
                        STRING(x-PreNew) + ',' +
                        STRING(x-PreOld) + ',' +
                        "E" + ',' +
                        STRING(VtaListaMay.TpoCmb) + ',' +
                        STRING(VtaListaMay.MonVta) + ',' +
                        s-User-Id,
                        OUTPUT pEstado).
END.

IF OldVtaListaMay.codmat <> '' THEN DO:
    IF VtaListaMay.PreOfi <> OldVtaListaMay.PreOfi
        OR VtaListaMay.CHR__01 <> OldVtaListaMay.CHR__01
        OR VtaListaMay.DtoVolD[1] <> OldVtaListaMay.DtoVolD[1] 
        OR VtaListaMay.DtoVolD[2] <> OldVtaListaMay.DtoVolD[2]  
        OR VtaListaMay.DtoVolD[3] <> OldVtaListaMay.DtoVolD[3] 
        OR VtaListaMay.DtoVolD[4] <> OldVtaListaMay.DtoVolD[4] 
        OR VtaListaMay.DtoVolD[5] <> OldVtaListaMay.DtoVolD[5] 
        OR VtaListaMay.DtoVolD[6] <> OldVtaListaMay.DtoVolD[6] 
        OR VtaListaMay.DtoVolD[7] <> OldVtaListaMay.DtoVolD[7] 
        OR VtaListaMay.DtoVolD[8] <> OldVtaListaMay.DtoVolD[8] 
        OR VtaListaMay.DtoVolD[9] <> OldVtaListaMay.DtoVolD[9] 
        OR VtaListaMay.DtoVolD[10] <> OldVtaListaMay.DtoVolD[10] 
        OR VtaListaMay.DtoVolR[1] <> OldVtaListaMay.DtoVolR[1] 
        OR VtaListaMay.DtoVolR[2] <> OldVtaListaMay.DtoVolR[2]
        OR VtaListaMay.DtoVolR[3] <> OldVtaListaMay.DtoVolR[3]
        OR VtaListaMay.DtoVolR[4] <> OldVtaListaMay.DtoVolR[4]
        OR VtaListaMay.DtoVolR[5] <> OldVtaListaMay.DtoVolR[5]
        OR VtaListaMay.DtoVolR[6] <> OldVtaListaMay.DtoVolR[6]
        OR VtaListaMay.DtoVolR[7] <> OldVtaListaMay.DtoVolR[7]
        OR VtaListaMay.DtoVolR[8] <> OldVtaListaMay.DtoVolR[8]
        OR VtaListaMay.DtoVolR[9] <> OldVtaListaMay.DtoVolR[9]
        OR VtaListaMay.DtoVolR[10] <> OldVtaListaMay.DtoVolR[10] 
        THEN DO:
        /* LOG de control */
        CREATE LogVtaListaMay.
        BUFFER-COPY VtaListaMay TO LogVtaListaMay
            ASSIGN
                LogVtaListaMay.LogEvento = "UPDATE"
                LogVtaListaMay.LogDate = TODAY
                LogVtaListaMay.LogTime = STRING(TIME, 'HH:MM:SS')
                LogVtaListaMay.LogUser = s-user-id.
    END.
END.
ELSE DO:
    /* LOG de control */
    CREATE LogVtaListaMay.
    BUFFER-COPY VtaListaMay TO LogVtaListaMay
        ASSIGN
            LogVtaListaMay.LogEvento = "CREATE"
            LogVtaListaMay.LogDate = TODAY
            LogVtaListaMay.LogTime = STRING(TIME, 'HH:MM:SS')
            LogVtaListaMay.LogUser = s-user-id.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-MAY_Actualiza-Descuentos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MAY_Actualiza-Descuentos Procedure 
PROCEDURE MAY_Actualiza-Descuentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pError AS CHAR NO-UNDO.

f-PrecioLista = VtaListaMay.PreOfi.

DEF BUFFER b-VtaDctoProm FOR VtaDctoProm.
DEF VAR LocalCuentaBloqueos AS INTE NO-UNDO.
DEF VAR LocalCuentaErrores AS INTE NO-UNDO.

IF (VtaListaMay.PreOfi <> OldVtaListaMay.PreOfi) THEN DO:
    /* Actualizamos VtaDctoProm: Promociones Vigentes */
    FOR EACH VtaDctoProm OF VtaListaMay NO-LOCK WHERE (TODAY >= VtaDctoProm.FchIni AND TODAY <= VtaDctoProm.FchFin):
        LocalCuentaBloqueos = 0.
        REPEAT:
            FIND FIRST b-VtaDctoProm WHERE ROWID(b-VtaDctoProm) = ROWID(VtaDctoProm) 
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-VtaDctoProm THEN LEAVE.
            LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
            IF LocalCuentaBloqueos > 1000 THEN DO:
                {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        IF b-VtaDctoProm.DescuentoVIP > 0 THEN b-VtaDctoProm.PrecioVIP = ROUND(f-PrecioLista * (1 - (b-VtaDctoProm.DescuentoVIP / 100)), 4).
        IF b-VtaDctoProm.DescuentoMR  > 0 THEN b-VtaDctoProm.PrecioMR  = ROUND(f-PrecioLista * (1 - (b-VtaDctoProm.DescuentoMR / 100)), 4).
        IF b-VtaDctoProm.Descuento    > 0 THEN b-VtaDctoProm.Precio    = ROUND(f-PrecioLista * (1 - (b-VtaDctoProm.Descuento / 100)), 4).
    END.
    /* Actualizamos VtaDctoProm: Promociones Proyectadas */
    FOR EACH VtaDctoProm OF VtaListaMay NO-LOCK WHERE VtaDctoProm.FchIni > TODAY:
        LocalCuentaBloqueos = 0.
        REPEAT:
            FIND FIRST b-VtaDctoProm WHERE ROWID(b-VtaDctoProm) = ROWID(VtaDctoProm) 
                EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAILABLE b-VtaDctoProm THEN LEAVE.
            LocalCuentaBloqueos = LocalCuentaBloqueos + 1.
            IF LocalCuentaBloqueos > 1000 THEN DO:
                {lib/mensaje-de-error.i &CuentaError="LocalCuentaErrores" &MensajeError="pError"}
                UNDO, RETURN 'ADM-ERROR'.
            END.
        END.
        IF b-VtaDctoProm.DescuentoVIP > 0 THEN b-VtaDctoProm.PrecioVIP = ROUND(f-PrecioLista * (1 - (b-VtaDctoProm.DescuentoVIP / 100)), 4).
        IF b-VtaDctoProm.DescuentoMR  > 0 THEN b-VtaDctoProm.PrecioMR  = ROUND(f-PrecioLista * (1 - (b-VtaDctoProm.DescuentoMR / 100)), 4).
        IF b-VtaDctoProm.Descuento    > 0 THEN b-VtaDctoProm.Precio    = ROUND(f-PrecioLista * (1 - (b-VtaDctoProm.Descuento / 100)), 4).
    END.
    /* Actualizamos Precio por Volumen */
    DO x-Item = 1 TO 10:
        IF VtaListaMay.DtoVolD[x-Item] <> 0 THEN
            ASSIGN VtaListaMay.DtoVolP[x-Item] = ROUND(f-PrecioLista * (1 - (VtaListaMay.DtoVolD[x-Item]  / 100)), 4).
    END.
END.
IF AVAILABLE(b-VtaDctoProm) THEN RELEASE b-VtaDctoProm.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-MAY_Importe-sin-igv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MAY_Importe-sin-igv Procedure 
PROCEDURE MAY_Importe-sin-igv :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Precio A */    
DEF VAR k AS INTE NO-UNDO.

IF VtaListaMay.PreOfi <> OLDVtaListaMay.PreOfi THEN DO:
    ASSIGN
        VtaListaMay.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        VtaListaMay.ImporteUnitarioSinImpuesto = ROUND(VtaListaMay.PreOfi / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        VtaListaMay.ImporteUnitarioImpuesto = VtaListaMay.PreOfi - VtaListaMay.ImporteUnitarioSinImpuesto
        .
END.
DO k = 1 TO 10:
    IF VtaListaMay.DtoVolP[k] <> OLDVtaListaMay.DtoVolP[k] THEN 
        ASSIGN
        VtaListaMay.TasaImpuesto = Sunat_Fact_Electr_Taxs.Tax
        VtaListaMay.DtoVolPSinImpuesto[k] = ROUND(VtaListaMay.DtoVolP[k] / ( 1 + Sunat_Fact_Electr_Taxs.Tax / 100), 4)
        VtaListaMay.DtoVolPImpuesto[k] = VtaListaMay.DtoVolP[k] - VtaListaMay.DtoVolPSinImpuesto[k]
        .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

