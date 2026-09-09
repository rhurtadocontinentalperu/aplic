&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
         HEIGHT             = 11
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Comprobantes Include 
PROCEDURE Crea-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       CREA TEMPORAL DE COMPROBANTES
------------------------------------------------------------------------------*/

DEFINE VARIABLE iCountItem AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE lCreaHeader AS LOGICAL NO-UNDO.
DEFINE VARIABLE lItemOk AS LOGICAL NO-UNDO.
DEFINE VARIABLE FILL-IN-items AS INT NO-UNDO.
DEFINE VARIABLE X_cto1 AS DEC NO-UNDO.
DEFINE VARIABLE X_cto2 AS DEC NO-UNDO.
DEFINE VARIABLE x-ImporteAcumulado AS DEC NO-UNDO.

/* CONSISTENCIA */
FOR EACH T-CODES NO-LOCK:
    /* Verifica Detalle */
    FOR EACH FacDPedi OF T-CODES NO-LOCK BY FacDPedi.NroItm:
        FIND Almmmate WHERE Almmmate.CodCia = FacDPedi.CodCia 
            AND Almmmate.CodAlm = FacDPedi.AlmDes 
            AND Almmmate.codmat = FacDPedi.CodMat 
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE Almmmate THEN DO:
            pMensaje = "Artículo " + FacDPedi.CodMat + " NO está asignado al almacén " + FacDPedi.AlmDes + CHR(10) +
                'Proceso abortado'.
            RETURN 'ADM-ERROR'.
        END.
    END.
END.
/*  FIN DE CONSISTENCIA */
FIND FacCfgGn WHERE FacCfgGn.CodCia = s-CodCia NO-LOCK NO-ERROR.
FILL-IN-items = 999999.     /* Sin Límites */
IF s-coddoc = 'BOL' THEN FILL-IN-items = FacCfgGn.Items_Boleta.
IF s-coddoc = 'FAC' THEN FILL-IN-items = FacCfgGn.Items_Factura.
RUN sunat\p-nro-items (s-CodDoc, s-PtoVta, OUTPUT FILL-IN-items).
/* ***************************************************************************** */
/* RHC 24/06/2016 TODO SE VA A CREAR EL TABLAS TEMPORALES                        */
/* ***************************************************************************** */

TRLOOP:    
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    pMensaje = "Tabla Faccorre bloqueada por otro usuario".
    /* Correlativo */
    {lib\lock-genericov3.i 
        &Tabla="FacCorre" ~
        &Alcance="FIRST"
        &Condicion="FacCorre.CodCia = s-CodCia ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.NroSer = s-PtoVta" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &TxtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    pMensaje = "".
    FOR EACH T-CODES:
        ASSIGN
            lCreaHeader = TRUE
            lItemOk     = FALSE.
        FOR EACH T-DODES OF T-CODES NO-LOCK,
            FIRST Almmmatg OF T-DODES NO-LOCK,
            FIRST Almmmate NO-LOCK WHERE Almmmate.CodCia = T-DODES.CodCia 
                AND Almmmate.CodAlm = T-DODES.AlmDes
                AND Almmmate.CodMat = T-DODES.CodMat
            BREAK BY T-DODES.CodCia BY T-DODES.CodMat:
            /* Crea Cabecera */
            IF lCreaHeader THEN DO:
                /* Cabecera del Comprobante */
                RUN proc_CreaCabecera.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO TRLOOP, RETURN 'ADM-ERROR'.
                ASSIGN
                    x_cto1 = 0
                    x_cto2 = 0
                    iCountItem = 1
                    lCreaHeader = FALSE
                    x-ImporteAcumulado = 0.
            END.
            /* Crea Detalle */
            FIND T-CDOCU WHERE ROWID(T-CDOCU) = Fac_Rowid.
            CREATE T-DDOCU.
            BUFFER-COPY T-DODES 
                TO T-DDOCU
                ASSIGN
                    T-DDOCU.NroItm = iCountItem
                    T-DDOCU.CodCia = T-CDOCU.CodCia
                    T-DDOCU.Coddoc = T-CDOCU.Coddoc
                    T-DDOCU.NroDoc = T-CDOCU.NroDoc 
                    T-DDOCU.FchDoc = T-CDOCU.FchDoc
                    T-DDOCU.CodDiv = T-CDOCU.CodDiv
                    T-DDOCU.CanDes = T-DODES.CanPed
                    T-DDOCU.Factor = T-DODES.Factor
                    T-DDOCU.UndVta = T-DODES.UndVta
                    T-DDOCU.ImpIgv = T-DODES.ImpIgv
                    T-DDOCU.ImpIsc = T-DODES.ImpIsc
                    T-DDOCU.ImpDto = T-DODES.ImpDto
                    T-DDOCU.ImpLin = T-DODES.ImpLin
                    T-DDOCU.impdcto_adelanto[4] = T-DODES.Libre_d02.  /* Flete Unitario */
            /* *********************************************** */
            x-ImporteAcumulado = x-ImporteAcumulado + T-DODES.ImpLin.
            /* Contador de registros válidos */
            iCountItem = iCountItem + 1.
            /* Guarda Costos */
            IF almmmatg.monvta = 1 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor,2).
                x_cto2 = ROUND((Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor) / Almmmatg.Tpocmb,2).
            END.
            IF almmmatg.monvta = 2 THEN DO:
                x_cto1 = ROUND(Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor * Almmmatg.TpoCmb, 2).
                x_cto2 = ROUND((Almmmatg.Ctotot * T-DDOCU.CanDes * T-DDOCU.Factor), 2).
            END.
            ASSIGN
                T-DDOCU.ImpCto = ( IF T-CDOCU.Codmon = 1 THEN x_cto1 ELSE x_cto2 )
                T-CDOCU.ImpCto = T-CDOCU.ImpCto + T-DDOCU.ImpCto.
            /* ************** */
            IF iCountItem > FILL-IN-items OR LAST-OF(T-DODES.CodCia) THEN DO:

                /* GRABAR LOS TOTALES DEl COMPROBANTE */

                RUN Graba-Totales-Factura.
                IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO trloop, RETURN 'ADM-ERROR'.
            END.
            /* ************** */
            IF iCountItem > FILL-IN-items THEN DO:
                iCountItem = 1.
                lCreaHeader = TRUE.
            END.
        END. /* FOR EACH T-DODES... */
    END.    /* FOR EACH T-CODES */
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Crea-Ordenes Include 
PROCEDURE Crea-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE x_igv AS DECIMAL NO-UNDO.
    DEFINE VARIABLE x_isc AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i_NPed   AS INTEGER INIT 0.
    DEFINE VARIABLE i_NItem  AS INTEGER INIT 0.


    EMPTY TEMP-TABLE T-CODES.
    EMPTY TEMP-TABLE T-DODES.

    /* Archivo de control */
    FIND FacCfgGn WHERE FacCfgGn.CodCia = s-codcia NO-LOCK NO-ERROR.

    DEFINE VARIABLE s-CodDoc AS CHAR NO-UNDO.
    DEFINE VARIABLE s-NroSer LIKE FacCorre.NroSer.
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
    DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
    DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

    /* GENERAMOS UNA O/M POR CADA ALMACÉN */
    ASSIGN
        s-CodDoc = "O/M".               /* ORDEN DE DESPACHO MOSTRADOR */
    FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
        FacCorre.CodDiv = s-CodDiv AND
        FacCorre.CodDoc = S-CODDOC AND
        FacCorre.FlgEst = YES
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE Faccorre THEN DO:
        pMensaje = 'NO está configurado el correlativo para el documento ' + s-coddoc + CHR(10) +
            'para la división ' + s-coddiv.
        RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        s-NroSer = FacCorre.NroSer.
    RLOOP:
    DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
        pMensaje = "Tabla Facorre en uso por otro usuario".
        {lib/lock-genericov3.i
            &Tabla="FacCorre"
            &Condicion="FacCorre.codcia = s-codcia ~
            AND FacCorre.coddoc = s-coddoc ~
            AND FacCorre.nroser = s-nroser"
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
            &Accion="RETRY"
            &Mensaje="NO"
            &TxtMensaje="pMensaje"
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'"
            }
        pMensaje = "".
        /* Barremos el P/M */
        FOR EACH B-DPEDM OF B-CPEDM NO-LOCK, FIRST Almacen NO-LOCK WHERE 
            Almacen.codcia = B-DPEDM.codcia AND Almacen.codalm = B-DPEDM.almdes
            BREAK BY B-DPEDM.almdes: 
            IF FIRST-OF(B-DPEDM.almdes) THEN DO:
                I-NITEM = 0.
                CREATE T-CODES.
                BUFFER-COPY B-CPEDM
                    EXCEPT 
                    B-CPEDM.FlgEst
                    B-CPEDM.FlgSit
                    TO T-CODES
                    ASSIGN 
                    T-CODES.CodCia = S-CODCIA
                    T-CODES.CodDiv = S-CODDIV
                    T-CODES.CodDoc = s-coddoc 
                    T-CODES.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
                    T-CODES.DivDes = Almacen.CodDiv    /* <<< OJO <<< */
                    T-CODES.CodAlm = Almacen.CodAlm    /* <<< OJO <<< */
                    T-CODES.FlgEst = 'P'               
                    T-CODES.CodRef = B-CPEDM.CodDoc    /* El Pedido */
                    T-CODES.NroRef = B-CPEDM.NroPed
                    T-CODES.TpoCmb = FacCfgGn.TpoCmb[1] 
                    T-CODES.Hora = STRING(TIME,"HH:MM")
                    T-CODES.FchPed = TODAY
                    T-CODES.FchVen = TODAY
                    NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    UNDO RLOOP, RETURN 'ADM-ERROR'.
                END.
                ASSIGN
                    FacCorre.Correlativo = FacCorre.Correlativo + 1.
                /* RHC solo cuando es por enviar */
                IF T-CODES.FlgEnv = YES THEN DO:
                    FIND gn-divi WHERE gn-divi.codcia = T-CODES.codcia
                        AND gn-divi.coddiv = T-CODES.divdes
                        NO-LOCK.
                    ASSIGN
                        s-FlgPicking = GN-DIVI.FlgPicking
                        s-FlgBarras  = GN-DIVI.FlgBarras
                        T-CODES.FchVen = TODAY + GN-DIVI.DiasVtoO_D.
                    IF s-FlgPicking = YES THEN T-CODES.FlgSit = "T".    /* Falta Pre-Picking */
                    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN T-CODES.FlgSit = "C".    /* Picking OK */
                    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN T-CODES.FlgSit = "P".   /* Falta Picking */
                    /* RHC 20/05/2019 NO pasa por picking */
                    T-CODES.FlgSit = "P".    /* Barras OK */
                END.
                ELSE T-CODES.FlgSit = "C".    /* Barras OK */
                /* ****************************** */
            END.
            I-NITEM = I-NITEM + 1.
            CREATE T-DODES. 
            BUFFER-COPY B-DPEDM 
                EXCEPT B-DPEDM.CanAte
                TO T-DODES
                ASSIGN  
                T-DODES.CodCia  = T-CODES.CodCia 
                T-DODES.coddiv  = T-CODES.coddiv 
                T-DODES.coddoc  = T-CODES.coddoc 
                T-DODES.NroPed  = T-CODES.NroPed 
                T-DODES.FchPed  = T-CODES.FchPed
                T-DODES.Hora    = T-CODES.Hora 
                T-DODES.FlgEst  = T-CODES.FlgEst
                T-DODES.NroItm  = I-NITEM
                T-DODES.CanPick = B-DPEDM.CanPed.     /* <<< OJO <<< */
        END.
    END.
    RETURN 'OK'.

              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Documentos-Anexos Include 
PROCEDURE Documentos-Anexos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cliename    LIKE Gn-Clie.Nomcli.
DEFINE VARIABLE clieruc     LIKE Gn-Clie.Ruc.
DEFINE INPUT PARAMETER NroDocCja AS CHARACTER.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    FIND FIRST T-CcbCCaja.
    /* Genera Cheque */
    IF ((T-CcbCCaja.Voucher[2] <> "") AND
        (T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2]) > 0) OR
        ((T-CcbCCaja.Voucher[3] <> "") AND
        (T-CcbCCaja.ImpNac[3] + T-CcbCCaja.ImpUsa[3]) > 0) THEN DO:
        FIND Gn-Clie WHERE
            Gn-Clie.Codcia = cl-codcia AND
            Gn-Clie.CodCli = T-CcbCCaja.Voucher[10]
            NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-Clie THEN
            ASSIGN
                cliename = Gn-Clie.Nomcli
                clieruc = Gn-Clie.Ruc.
        CREATE CcbCDocu.
        ASSIGN
            CcbCDocu.CodCia = S-CodCia
            CcbCDocu.CodDiv = S-CodDiv
            CcbCDocu.CodDoc = "CHC"
            CcbCDocu.CodCli = T-CcbCCaja.Voucher[10]
            CcbCDocu.NomCli = cliename
            CcbCDocu.RucCli = clieruc
            CcbCDocu.FlgEst = "P"
            CcbCDocu.Usuario = s-User-Id
            CcbCDocu.TpoCmb = T-CcbCCaja.TpoCmb
            CcbCDocu.FchDoc = TODAY.
        IF T-CcbCCaja.ImpNac[2] + T-CcbCCaja.ImpUsa[2] > 0 THEN
            ASSIGN
                CcbCDocu.NroDoc = T-CcbCCaja.Voucher[2]
                CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[2] <> 0 THEN 1 ELSE 2
                CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[2] <> 0 THEN
                    T-ccbCCaja.ImpNac[2] ELSE T-ccbCCaja.ImpUsa[2]
                CcbCDocu.FchVto = T-CcbCCaja.FchVto[2]
                        NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Cheque CHC " + T-CcbCCaja.Voucher[2] + " ya registrado".
                UNDO, RETURN "ADM-ERROR".
            END.
        ELSE
            ASSIGN
                CcbCDocu.NroDoc = T-CcbCCaja.Voucher[3]
                CcbCDocu.CodMon = IF T-ccbCCaja.ImpNac[3] <> 0 THEN 1 ELSE 2
                CcbCDocu.ImpTot = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.SdoAct = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.ImpBrt = IF T-ccbCCaja.ImpNac[3] <> 0 THEN
                    T-ccbCCaja.ImpNac[3] ELSE T-ccbCCaja.ImpUsa[3]
                CcbCDocu.FchVto = T-CcbCCaja.FchVto[3]
                        NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Cheque CHC " + T-CcbCCaja.Voucher[3] + " ya registrado".
                UNDO, RETURN "ADM-ERROR".
            END.
    END.
    /* Actualiza la Boleta de Deposito */
    IF T-CcbCCaja.Voucher[5] <> "" AND (T-CcbCCaja.ImpNac[5] + T-CcbCCaja.ImpUsa[5]) > 0 
        THEN DO:
        RUN proc_AplicaDoc(
            "BD",
            T-CcbCCaja.Voucher[5],
            NroDocCja,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[5],
            T-CcbCCaja.ImpUsa[5]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear la Boleta de Depósito".
            UNDO, RETURN "ADM-ERROR".
        END.
    END.

    /* Aplica Nota de Credito */
    IF CAN-FIND(FIRST wrk_dcaja) THEN DO:
        FOR EACH wrk_dcaja NO-LOCK,
            FIRST CcbCDocu WHERE CcbCDocu.CodCia = wrk_dcaja.CodCia
            AND CcbCDocu.CodCli = wrk_dcaja.CodCli
            AND CcbCDocu.CodDoc = wrk_dcaja.CodRef
            AND CcbCDocu.NroDoc = wrk_dcaja.NroRef NO-LOCK:
            RUN proc_AplicaDoc(
                CcbCDocu.CodDoc,
                CcbCDocu.NroDoc,
                NroDocCja,
                T-CcbCCaja.tpocmb,
                IF CcbCDocu.CodMon = 1 THEN wrk_dcaja.Imptot ELSE 0,
                IF CcbCDocu.CodMon = 2 THEN wrk_dcaja.Imptot ELSE 0
                ).
            IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
                IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo aplicar la Nota de Crédito".
                UNDO RLOOP, RETURN "ADM-ERROR".
            END.
        END.
    END.

    /* Aplica de Anticipo */
    IF T-CcbCCaja.Voucher[7] <> "" AND
        (T-CcbCCaja.ImpNac[7] + T-CcbCCaja.ImpUsa[7]) > 0 THEN DO:
        RUN proc_AplicaDoc(
            "A/R",
            T-CcbCCaja.Voucher[7],
            NroDocCja,
            T-CcbCCaja.tpocmb,
            T-CcbCCaja.ImpNac[7],
            T-CcbCCaja.ImpUsa[7]
            ).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo aplicar el Anticipo".
            UNDO, RETURN "ADM-ERROR".
        END.
    END.
    /* Retenciones */
    IF CAN-FIND(FIRST wrk_ret) THEN DO:
        FOR EACH wrk_ret:
            wrk_ret.NroRef = NroDocCja.
        END.
        RUN proc_CreaRetencion.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > "") THEN pMensaje = "NO se pudo crear las Retenciones".
            UNDO, RETURN "ADM-ERROR".
        END.
    END.
END.
RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-SubPedidos Include 
PROCEDURE Genera-SubPedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* SOLO para O/D control de Pickeo */
IF FacCPedi.FlgSit <> "T" THEN RETURN 'OK'.

DEFINE VAR lSector AS CHAR.

/* Los subpedidos se generan de acuerdo al SECTOR donde esten ubicados los productos */
/* El SECTOR forma parte del código de ubicación */
FOR EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
    AND Almmmate.CodAlm = facdpedi.almdes
    AND Almmmate.codmat = facdpedi.codmat
    BREAK BY SUBSTRING(Almmmate.CodUbi,1,2):
    IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:

        /* Ic - 29Nov2016, G- = G0 */
        lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
        lSector = IF(lSector = 'G-') THEN 'G0' ELSE lSector.
        /* Ic - 29Nov2016, FIN  */                                                   

        CREATE vtacdocu.        
        BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN 
            VtaCDocu.CodCia = faccpedi.codcia
            VtaCDocu.CodDiv = faccpedi.coddiv
            VtaCDocu.CodPed = faccpedi.coddoc
            VtaCDocu.NroPed = faccpedi.nroped + '-' + lSector
            VtaCDocu.FlgEst = 'P'   /* APROBADO */
            VtaCDocu.libre_c05 = ''
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Error al grabar la suborden " + faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END.
    CREATE vtaddocu.
    BUFFER-COPY facdpedi TO vtaddocu
        ASSIGN
        VtaDDocu.CodCia = VtaCDocu.codcia
        VtaDDocu.CodDiv = VtaCDocu.coddiv
        VtaDDocu.CodPed = VtaCDocu.codped
        VtaDDocu.NroPed = VtaCDocu.nroped
        VtaDDocu.CodUbi = Almmmate.CodUbi.
END.
IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Comprobantes Include 
PROCEDURE Graba-Comprobantes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       VAMOS A SUPONER QUE SOLO ES UN COMPROBANTE EN CAJA MOSTRADOR
------------------------------------------------------------------------------*/

/* OJO: Si un documento YA PASÓ por el e-Pos NO SE PUEDE DESAPARACER
        Hay que marcarlo como ANULADO 
*/
/* Primero Creamos los Comprobantes */
pMensaje = "".
/* Guardamos el comprobante anterior para la nueva factura por TRANSFERENCIA GRATUITA */
DEF VAR x-OldNumber AS CHAR NO-UNDO.

PRIMERO:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CDOCU NO-LOCK:
        CREATE Ccbcdocu.
        BUFFER-COPY T-CDOCU TO Ccbcdocu NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
            UNDO PRIMERO, RETURN 'ADM-ERROR'.
        END.
        IF Ccbcdocu.FmaPgo = '899' THEN DO:  /* Nunca va a ser el primer documento */
            IF x-OldNumber > '' THEN Ccbcdocu.Glosa = x-OldNumber.
        END.
        x-OldNumber = Ccbcdocu.CodDoc + " " + Ccbcdocu.NroDoc.
        FOR EACH T-DDOCU OF T-CDOCU NO-LOCK:
            CREATE Ccbddocu.
            BUFFER-COPY T-DDOCU TO Ccbddocu NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Correlativo errado o duplicado: " + T-CDOCU.coddoc + " " +  T-CDOCU.nrodoc.
                UNDO PRIMERO, RETURN 'ADM-ERROR'.
            END.
        END.
    END.
END.
/* Segundo Actualizamos Almacenes */
pMensaje = "".
SEGUNDO:
FOR EACH T-CDOCU NO-LOCK TRANSACTION:
    FIND Ccbcdocu OF T-CDOCU NO-LOCK NO-ERROR.
    /* ACTUALIZAMOS ALMACENES */
    RUN vta2/act_almv2 ( INPUT ROWID(CcbCDocu), OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: NO se pudo actualizar el Kardex".
        UNDO SEGUNDO, RETURN 'ADM-ERROR'.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Ordenes Include 
PROCEDURE Graba-Ordenes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH T-CODES NO-LOCK:
        CREATE FacCPedi.
        BUFFER-COPY T-CODES TO FacCPedi NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Correlativo errado o duplicado: " + T-CODES.coddoc + " " +  T-CODES.nroped.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        FOR EACH T-DODES OF T-CODES NO-LOCK:
            CREATE FacDPedi.
            BUFFER-COPY T-DODES TO FacDPedi NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Correlativo errado o duplicado: " + T-CODES.coddoc + " " +  T-CODES.nroped.
                UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
            END.
        END.
        /* TRACKING */
        RUN vtagn/pTracking-04 (T-CODES.CodCia,
                                T-CODES.CodDiv,
                                T-CODES.CodRef,
                                T-CODES.NroRef,
                                s-User-Id,
                                'GOD',
                                'P',
                                DATETIME(TODAY, MTIME),
                                DATETIME(TODAY, MTIME),
                                T-CODES.CodDoc,
                                T-CODES.NroPed,
                                T-CODES.CodRef,
                                T-CODES.NroRef).
/*         RUN Genera-SubPedidos.                                                                            */
/*         IF RETURN-VALUE = 'ADM-ERROR' THEN DO:                                                            */
/*             IF pMensaje = '' THEN pMensaje = "No se pudo generar el detalle de la Sub-Orden de Despacho". */
/*             UNDO PRINCIPAL, RETURN 'ADM-ERROR'.                                                           */
/*         END.                                                                                              */
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_AplicaDoc Include 
PROCEDURE proc_AplicaDoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE INPUT PARAMETER para_CodDoc LIKE CcbCDocu.CodDoc.
    DEFINE INPUT PARAMETER para_NroDoc LIKE CcbDMov.NroDoc.
    DEFINE INPUT PARAMETER para_NroDocCja LIKE CcbDMov.NroDoc.    
    DEFINE INPUT PARAMETER para_TpoCmb LIKE CCBDMOV.TpoCmb.
    DEFINE INPUT PARAMETER para_ImpNac LIKE CcbDMov.ImpTot.
    DEFINE INPUT PARAMETER para_ImpUSA LIKE CcbDMov.ImpTot.

    /* Tipo de Documento */
    FIND FacDoc WHERE
        FacDoc.CodCia = s-CodCia AND
        FacDoc.CodDoc = para_CodDoc
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacDoc THEN DO:
        MESSAGE
            para_CodDoc 'NO CONFIGURADO'
            VIEW-AS ALERT-BOX ERROR.
        RETURN "ADM-ERROR".
    END.

    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        /* Busca Documento */
        {lib\lock-genericov21.i &Tabla="B-CDOCU" ~
            &Alcance="FIRST" ~
            &Condicion="B-CDocu.CodCia = s-codcia ~
            AND B-CDocu.CodDoc = para_CodDoc ~
            AND B-CDocu.NroDoc = para_NroDoc" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }

        /* Crea Detalle de la Aplicación */
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = s-CodCia
            CCBDMOV.CodDiv = s-CodDiv
            CCBDMOV.NroDoc = B-CDocu.NroDoc
            CCBDMOV.CodDoc = B-CDocu.CodDoc
            CCBDMOV.CodMon = B-CDocu.CodMon
            CCBDMOV.CodRef = s-CodCja
            CCBDMOV.NroRef = para_NroDocCja
            CCBDMOV.CodCli = B-CDocu.CodCli
            CCBDMOV.FchDoc = B-CDocu.FchDoc
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.TpoCmb = para_tpocmb
            CCBDMOV.usuario = s-User-ID.
        IF B-CDocu.CodMon = 1 THEN
            ASSIGN CCBDMOV.ImpTot = para_ImpNac.
        ELSE ASSIGN CCBDMOV.ImpTot = para_ImpUSA.
        IF FacDoc.TpoDoc THEN
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct + CCBDMOV.ImpTot.
        ELSE
            ASSIGN B-CDocu.SdoAct = B-CDocu.SdoAct - CCBDMOV.ImpTot.
        /* Cancela Documento */
        IF B-CDocu.SdoAct = 0 THEN
            ASSIGN 
                B-CDocu.FlgEst = "C"
                B-CDocu.FchCan = TODAY.
        ELSE
            ASSIGN
                B-CDocu.FlgEst = "P"
                B-CDocu.FchCan = ?.
        /* RHC 26/08/2015 Chequeo adicional */
        IF B-CDOCU.SdoAct < 0 THEN DO:
            pMensaje = "ERROR en el saldo del documento: " + B-CDocu.coddoc + " " + B-CDocu.nrodoc.
            UNDO, RETURN 'ADM-ERROR'.
        END.
    END. /* DO TRANSACTION... */
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_CreaRetencion Include 
PROCEDURE proc_CreaRetencion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST T-CcbCCaja NO-ERROR.
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        FOR EACH wrk_ret NO-LOCK:
            FIND FIRST CCBCMOV WHERE
                CCBCMOV.CodCia = wrk_ret.CodCia AND
                CCBCMOV.CodDoc = wrk_ret.CodDoc AND
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                NO-LOCK NO-ERROR.
            IF AVAILABLE CCBCMOV THEN DO:
                pMensaje = "YA EXISTE RETENCION PARA DOCUMENTO " + CCBCMOV.CodDoc + " " + CCBCMOV.NroDoc + CHR(10) +
                    "CREADO POR: " + CCBCMOV.usuario + CHR(10) + 
                    "FECHA: " + STRING(CCBCMOV.FchMov) + CHR(10) +
                    "HORA: " + CCBCMOV.HraMov.
                UNDO, RETURN 'ADM-ERROR'.
            END.
            CREATE CCBCMOV.
            ASSIGN
                CCBCMOV.CodCia = wrk_ret.CodCia
                CCBCMOV.CodDoc = wrk_ret.CodDoc
                CCBCMOV.NroDoc = wrk_ret.NroDoc
                CCBCMOV.CodRef = wrk_ret.CodRef
                CCBCMOV.NroRef = wrk_ret.NroRef
                CCBCMOV.CodCli = wrk_ret.CodCli
                CCBCMOV.CodDiv = s-CodDiv
                CCBCMOV.CodMon = 1                  /* Ojo: Siempre en Soles */
                CCBCMOV.TpoCmb = T-CcbCCaja.TpoCmb
                CCBCMOV.FchDoc = wrk_ret.FchDoc
                CCBCMOV.ImpTot = wrk_ret.ImpTot
                CCBCMOV.DocRef = wrk_ret.NroRet     /* Comprobante */
                CCBCMOV.FchRef = wrk_ret.FchRet     /* Fecha */
                CCBCMOV.ImpRef = wrk_ret.ImpRet     /* Importe */
                CCBCMOV.FchMov = TODAY
                CCBCMOV.HraMov = STRING(TIME,"HH:MM:SS")
                CCBCMOV.usuario = s-User-ID
                CCBCMOV.chr__01 = cNomcli.
        END.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_IngCja Include 
PROCEDURE proc_IngCja :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE OUTPUT PARAMETER para_nrodoccja LIKE CcbCCaja.NroDoc.
    DEFINE VARIABLE x_NumDoc AS CHARACTER.

    trloop:
    DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
        pMensaje = "Tabla Faccorre en uso por otro usuario".
        {lib\lock-genericov3.i &Tabla="FacCorre" ~
            &Alcance="FIRST"
            &Condicion="FacCorre.CodCia = s-codcia ~
            AND FacCorre.CodDiv = s-coddiv ~
            AND FacCorre.CodDoc = s-codcja ~
            AND FacCorre.NroSer = s-sercja" ~
            &Bloqueo="EXCLUSIVE-LOCK" ~
            &Accion="RETRY" ~
            &Mensaje="NO" ~
            &txtMensaje="pMensaje" ~
            &TipoError="UNDO, RETURN 'ADM-ERROR'" }
        pMensaje = "".
        FIND FIRST T-CcbCCaja.
        /* Crea Cabecera de Caja */
        CREATE CcbCCaja.
        ASSIGN
            CcbCCaja.CodCia     = s-CodCia
            CcbCCaja.CodDiv     = s-CodDiv 
            CcbCCaja.CodDoc     = s-CodCja
            CcbCCaja.NroDoc     = STRING(FacCorre.NroSer,"999") +
                                    STRING(FacCorre.Correlativo,"999999")
            CcbCCaja.CodCaja    = s-CodTer
            CcbCCaja.usuario    = s-user-id
            CcbCCaja.CodCli     = B-CPEDM.codcli
            CcbCCaja.NomCli     = B-CPEDM.NomCli
            CcbCCaja.CodMon     = B-CPEDM.CodMon
            CcbCCaja.FchDoc     = TODAY
            CcbCCaja.CodBco[1]  = T-CcbCCaja.CodBco[1]
            CcbCCaja.CodBco[2]  = T-CcbCCaja.CodBco[2]
            CcbCCaja.CodBco[3]  = T-CcbCCaja.CodBco[3]
            CcbCCaja.CodBco[4]  = T-CcbCCaja.CodBco[4]
            CcbCCaja.CodBco[5]  = T-CcbCCaja.CodBco[5]
            CcbCCaja.CodBco[6]  = T-CcbCCaja.CodBco[6]
            CcbCCaja.CodBco[8]  = T-CcbCCaja.CodBco[8]
            CcbCCaja.ImpNac[1]  = T-CcbCCaja.ImpNac[1]
            CcbCCaja.ImpNac[2]  = T-CcbCCaja.ImpNac[2]
            CcbCCaja.ImpNac[3]  = T-CcbCCaja.ImpNac[3]
            CcbCCaja.ImpNac[4]  = T-CcbCCaja.ImpNac[4]
            CcbCCaja.ImpNac[5]  = T-CcbCCaja.ImpNac[5]
            CcbCCaja.ImpNac[6]  = T-CcbCCaja.ImpNac[6]
            CcbCCaja.ImpNac[7]  = T-CcbCCaja.ImpNac[7]            
            CcbCCaja.ImpNac[8]  = T-CcbCCaja.ImpNac[8]
            CcbCCaja.ImpNac[9]  = T-CcbCCaja.ImpNac[9]
            CcbCCaja.ImpNac[10] = T-CcbCCaja.ImpNac[10]
            CcbCCaja.ImpUsa[1]  = T-CcbCCaja.ImpUsa[1]
            CcbCCaja.ImpUsa[2]  = T-CcbCCaja.ImpUsa[2]
            CcbCCaja.ImpUsa[3]  = T-CcbCCaja.ImpUsa[3]
            CcbCCaja.ImpUsa[4]  = T-CcbCCaja.ImpUsa[4] 
            CcbCCaja.ImpUsa[5]  = T-CcbCCaja.ImpUsa[5]
            CcbCCaja.ImpUsa[6]  = T-CcbCCaja.ImpUsa[6]
            CcbCCaja.ImpUsa[7]  = T-CcbCCaja.ImpUsa[7]
            CcbCCaja.ImpUsa[8]  = T-CcbCCaja.ImpUsa[8]
            CcbCCaja.ImpUsa[9]  = T-CcbCCaja.ImpUsa[9]
            CcbCCaja.ImpUsa[10] = T-CcbCCaja.ImpUsa[10]
            CcbCCaja.Tipo       = s-Tipo
            CcbCCaja.TpoCmb     = T-CcbCCaja.TpoCmb
            CcbCCaja.Voucher[2] = T-CcbCCaja.Voucher[2]
            CcbCCaja.Voucher[3] = T-CcbCCaja.Voucher[3]
            CcbCCaja.Voucher[4] = T-CcbCCaja.Voucher[4] 
            CcbCCaja.Voucher[5] = T-CcbCCaja.Voucher[5] 
            CcbCCaja.Voucher[6] = T-CcbCCaja.Voucher[6]
            CcbCCaja.Voucher[7] = T-CcbCCaja.Voucher[7]
            CcbCCaja.Voucher[8] = T-CcbCCaja.Voucher[8]
            CcbCCaja.Voucher[9] = T-CcbCCaja.Voucher[9]
            CcbCCaja.Voucher[10] = T-CcbCCaja.Voucher[10]
            CcbCCaja.FchVto[2]  = T-CcbCCaja.FchVto[2]
            CcbCCaja.FchVto[3]  = T-CcbCCaja.FchVto[3]
            CcbCCaja.VueNac     = T-CcbCCaja.VueNac 
            CcbCCaja.VueUsa     = T-CcbCCaja.VueUsa
            CcbCCaja.FLGEST     = "C"
            NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = "Revisar el correlativo del I/C".
            UNDO TRLOOP, RETURN 'ADM-ERROR'.
        END.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
        ASSIGN
            CcbCCaja.TarPtoNac = T-CcbCCaja.TarPtoNac
            CcbCCaja.TarPtoUsa = T-CcbCCaja.TarPtoUsa
            CcbCCaja.TarPtoBco = T-CcbCCaja.TarPtoBco 
            CcbCCaja.TarPtoNro = T-CcbCCaja.TarPtoNro 
            CcbCCaja.TarPtoTpo = T-CcbCCaja.TarPtoTpo.
        /* Crea Detalle de Caja */
        FOR EACH T-CDOCU BY T-CDOCU.NroDoc:
            CREATE CcbDCaja.
            ASSIGN
                CcbDCaja.CodCia = CcbCCaja.CodCia
                CcbdCaja.CodDiv = CcbCCaja.CodDiv
                CcbDCaja.CodDoc = CcbCCaja.CodDoc
                CcbDCaja.NroDoc = CcbCCaja.NroDoc
                CcbDCaja.CodRef = T-CDOCU.CodDoc
                CcbDCaja.NroRef = T-CDOCU.NroDoc
                CcbDCaja.CodCli = T-CDOCU.CodCli
                CcbDCaja.CodMon = T-CDOCU.CodMon
                CcbDCaja.FchDoc = CcbCCaja.FchDoc
                CcbDCaja.ImpTot = T-CDOCU.ImpTot
                CcbDCaja.TpoCmb = CcbCCaja.TpoCmb.
            ASSIGN
                T-CDOCU.FlgEst = "C"
                T-CDOCU.FchCan = TODAY
                T-CDOCU.SdoAct = 0.
        END.
        /* Cancelación por Cheque */
        IF T-CcbCCaja.Voucher[2] <> "" OR T-CcbCCaja.Voucher[3] <> "" THEN DO:
            IF T-CcbCCaja.Voucher[2] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[2].
            IF T-CcbCCaja.Voucher[3] <> "" THEN x_NumDoc = T-CcbCCaja.Voucher[3].       
            FIND CcbCDocu WHERE 
                CcbCDocu.CodCia = S-CodCia AND
                CcbCDocu.CodDiv = S-CodDiv AND
                CcbCDocu.CodDoc = "CHC" AND
                CcbCDocu.NroDoc = x_NumDoc
                EXCLUSIVE-LOCK NO-ERROR. 
            IF AVAILABLE CcbCDocu THEN
                ASSIGN
                    CcbCDocu.CodRef = CcbCCaja.CodDoc 
                    CcbCDocu.NroRef = CcbCCaja.NroDoc.               
        END.
        /* Captura Nro de Caja */
        para_nrodoccja = CcbCCaja.NroDoc.
    END.
    RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc_verifica_ic Include 
PROCEDURE proc_verifica_ic :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    DEFINE VARIABLE lFoundIC AS LOGICAL NO-UNDO.

    /* Busca I/C tipo "Sencillo" Activo */
    IF NOT s-codter BEGINS "ATE" THEN DO:
        lFoundIC = FALSE.
        FOR EACH ccbccaja WHERE
            ccbccaja.codcia = s-codcia AND
            ccbccaja.coddiv = s-coddiv AND 
            ccbccaja.tipo = "SENCILLO" AND
            ccbccaja.codcaja = s-codter AND
            ccbccaja.usuario = s-user-id AND
            ccbccaja.coddoc = "I/C" AND
            ccbccaja.flgcie = "P" NO-LOCK:
            IF CcbCCaja.FlgEst <> "A" THEN lFoundIC = TRUE.
        END.
        IF NOT lFoundIC THEN DO:
            MESSAGE
                "Se debe ingresar el I/C SENCILLO como primer movimiento"
                VIEW-AS ALERT-BOX ERROR.
            RETURN 'ADM-ERROR'.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Temporal-de-Retenciones Include 
PROCEDURE Temporal-de-Retenciones :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE dTpoCmb     LIKE CcbcCaja.TpoCmb NO-UNDO.

/* Retenciones */
EMPTY TEMP-TABLE wrk_ret.
/* N/C */
EMPTY TEMP-TABLE wrk_dcaja.
/* RHC 19/12/2015 Bloqueado a solicitud de Susana Leon */
RETURN.
/* *************************************************** */

    IF B-CPEDM.CodDoc = "FAC" AND       /* Solo Facturas */
        B-CPEDM.ImpTot > 0 THEN DO:
        /* Tipo de Cambio Caja */
        dTpoCmb = 1.
        FIND LAST Gn-tccja WHERE Gn-tccja.Fecha <= TODAY NO-LOCK NO-ERROR.
        IF AVAILABLE Gn-tccja THEN DO:
            IF B-CPEDM.Codmon = 1 THEN dTpoCmb = Gn-tccja.Compra.
            ELSE dTpoCmb = Gn-tccja.Venta.
        END.
        FIND gn-clie WHERE
            gn-clie.codcia = cl-codcia AND
            gn-clie.codcli = B-CPEDM.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie AND gn-clie.rucold = "Si" THEN DO:     /* AGENTE RETENEDOR */
            CREATE wrk_ret.
            ASSIGN
                wrk_ret.CodCia = B-CPEDM.Codcia
                wrk_ret.CodCli = B-CPEDM.CodCli
                wrk_ret.CodDoc = B-CPEDM.CodDoc
                wrk_ret.NroDoc = B-CPEDM.NroPed
                wrk_ret.FchDoc = B-CPEDM.FchPed
                wrk_ret.CodRef = s-CodCja                    
                wrk_ret.NroRef = ""
                wrk_ret.CodMon = "S/."
                cNomcli = gn-clie.nomcli.
            /* OJO: Cálculo de Retenciones Siempre en Soles */
            IF B-CPEDM.Codmon = 1 THEN DO:
                wrk_ret.ImpTot = B-CPEDM.imptot.
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
            ELSE DO:
                wrk_ret.ImpTot = ROUND((B-CPEDM.imptot * dTpoCmb),2).
                wrk_ret.ImpRet = ROUND((wrk_ret.ImpTot * (6 / 100)),2).
            END.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

