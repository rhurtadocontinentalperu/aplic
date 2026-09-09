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

DEF INPUT PARAMETER pCodDiv AS CHAR.
DEF INPUT PARAMETER pCodDoc AS CHAR.
DEF INPUT PARAMETER pNroDoc AS CHAR.

/*DEF INPUT PARAMETER pRowid AS ROWID.*/
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

FIND CcbCCaja WHERE CcbCCaja.codcia = s-codcia
    AND CcbCCaja.coddiv = pCodDiv
    AND CcbCCaja.coddoc = pCodDoc
    AND CcbCCaja.nrodoc = pNroDoc
    NO-LOCK NO-ERROR.
/*FIND CcbCCaja WHERE ROWID(CcbCCaja) = pRowid NO-LOCK NO-ERROR.*/
IF NOT AVAILABLE CcbCCaja THEN RETURN 'OK'.

DEF BUFFER b-ccbcdocu FOR ccbcdocu.
DEF BUFFER b-ccbccaja FOR ccbccaja.

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
         HEIGHT             = 5.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

trloop:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="CcbCCaja" ~
        &Condicion="CcbCCaja.codcia = s-codcia ~
            AND CcbCCaja.coddiv = pCodDiv ~
            AND CcbCCaja.coddoc = pCodDoc ~
            AND CcbCCaja.nrodoc = pNroDoc" ~
        /*&Condicion="ROWID(Ccbccaja) = pRowid" ~*/
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="YES" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" ~
        }
    ASSIGN Ccbccaja.flgest = "A".
    /* Extorna Saldos y Anula documentos */
    RUN Extorna-Saldos.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.

    /* EXTORNOS OTROS DOCUMENTOS DE CAJA */
    RUN Extorna-Otros.
    IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN 'ADM-ERROR'.

END. /* DO TRANSACTION... */
IF AVAILABLE(b-ccbccaja) THEN  RELEASE b-ccbccaja.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(ccbcdocu) THEN RELEASE ccbcdocu.
IF AVAILABLE(ccbddocu) THEN RELEASE ccbddocu.
IF AVAILABLE(ccbaudit) THEN RELEASE ccbaudit.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Extorna-Otros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Otros Procedure 
PROCEDURE Extorna-Otros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE x_nrodoc AS CHARACTER NO-UNDO.
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":
    /* EXTORNOS DE CHEQUES */
    /* Cheque */
    IF ((CcbCCaja.Voucher[2] <> "" ) AND
        (CcbCCaja.ImpNac[2] + CcbCCaja.ImpUsa[2]) > 0 ) OR
        ((CcbCCaja.Voucher[3] <> "" ) AND
        (CcbCCaja.ImpNac[3] + CcbCCaja.ImpUsa[3]) > 0) THEN DO:
        FIND CcbCDocu WHERE
            CcbCDocu.CodCia = CcbCCaja.CodCia AND
            CcbCDocu.CodDoc = "CHC" AND
            CcbCDocu.NroDoc = x_nrodoc
            EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE CcbCDocu THEN DELETE CcbCDocu.
    END.
    /* Elimina Detalle de la Aplicación para N/C y A/R y BD */
    FOR EACH CCBDMOV EXCLUSIVE-LOCK WHERE CCBDMOV.CodCia = ccbccaja.CodCia 
            AND CCBDMOV.CodDiv = ccbccaja.CodDiv 
            AND CCBDMOV.CodRef = ccbccaja.coddoc 
            AND CCBDMOV.NroRef = ccbccaja.nrodoc:
        /* Tipo de Documento */
        FIND FacDocum WHERE FacDocum.CodCia = CCBDMOV.CodCia 
            AND FacDocum.CodDoc = CCBDMOV.CodDoc
            NO-LOCK NO-ERROR.
        IF NOT AVAILABLE FacDocum THEN RETURN "ADM-ERROR".
        FIND FIRST CcbCDocu WHERE CcbCDocu.codcia = CCBDMOV.CodCia 
            AND CcbCDocu.coddoc = CCBDMOV.CodDoc 
            AND CcbCDocu.nrodoc = CCBDMOV.NroDoc EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE ccbcdocu THEN RETURN "ADM-ERROR".
        IF FacDocum.TpoDoc THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CCBDMOV.Imptot.
        ELSE CcbCDocu.SdoAct = CcbCDocu.SdoAct + CCBDMOV.Imptot.
        /* Cancela Documento */
        IF CcbCDocu.SdoAct <> 0 
            THEN ASSIGN
                    CcbCDocu.FlgEst = "P"
                    CcbCDocu.FchCan = ?.
        DELETE CCBDMOV.
    END.
    /* Extorna Retencion */
    FOR EACH CcbCMov EXCLUSIVE-LOCK WHERE CCBCMOV.CodCia = CcbCCaja.CodCia 
        AND CCBCMOV.CodRef = CcbCCaja.CodDoc 
        AND CCBCMOV.NroRef = CcbCCaja.NroDoc:
        DELETE CcbCMov.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Extorna-Saldos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Extorna-Saldos Procedure 
PROCEDURE Extorna-Saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FOR EACH ccbdcaja OF ccbccaja NO-LOCK:
        {lib/lock-genericov3.i ~
            &Tabla="Ccbcdocu" ~
            &Condicion="ccbcdocu.codcia = ccbdcaja.codcia ~
            AND ccbcdocu.coddoc = ccbdcaja.codref ~
            AND ccbcdocu.nrodoc = ccbdcaja.nroref" ~
            &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
            &Accion="RETRY" ~
            &Mensaje="YES" ~
            &TipoError="UNDO RLOOP, RETURN 'ADM-ERROR'" ~
            }
        ASSIGN
            CcbCdocu.sdoact = 0
            CcbCdocu.fchcan = ?
            CcbCdocu.flgest = "A"
            CcbCdocu.FchAnu = TODAY
            CcbCdocu.UsuAnu = S-USER-ID.
        /* TRACKING FACTURAS */
        RUN vtagn/pTracking-04 (Ccbcdocu.CodCia,
                        Ccbccaja.CodDiv,
                        Ccbcdocu.CodPed,
                        Ccbcdocu.NroPed,
                        s-User-Id,
                        'EFAC',
                        'A',
                        DATETIME(TODAY, MTIME),
                        DATETIME(TODAY, MTIME),
                        Ccbcdocu.coddoc,
                        Ccbcdocu.nrodoc,
                        CcbCDocu.Libre_c01,
                        CcbCDocu.Libre_c02).
        /* EXTORNAMOS CONTROL DE PERCEPCIONES POR CARGOS */
        FOR EACH b-ccbcdocu EXCLUSIVE-LOCK WHERE b-ccbcdocu.codcia = Ccbcdocu.codcia
            AND b-ccbcdocu.coddiv = Ccbcdocu.coddiv
            AND b-ccbcdocu.coddoc = "PRC"
            AND b-ccbcdocu.codref = Ccbcdocu.coddoc
            AND b-ccbcdocu.nroref = Ccbcdocu.nrodoc:
            DELETE b-ccbcdocu.
        END.
        /* ********************************************* */
        /* Extorno Ordenes de Despacho */
        FOR EACH Faccpedi EXCLUSIVE-LOCK WHERE Faccpedi.codcia = Ccbcdocu.codcia
            AND Faccpedi.coddiv = Ccbcdocu.coddiv
            AND Faccpedi.coddoc = Ccbcdocu.libre_c01
            AND Faccpedi.nroped = Ccbcdocu.libre_c02:
            ASSIGN
                Faccpedi.FlgEst = "A".
            /* TRACKING */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodRef,
                                    Faccpedi.NroRef,
                                    s-User-Id,
                                    'GOD',
                                    'A',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    Faccpedi.CodRef,
                                    Faccpedi.NroRef).
        END.
        /* RHC 20/08/2015 Extorna Pedidos de Mostrador (O/M) */
        FOR EACH Faccpedi EXCLUSIVE-LOCK WHERE Faccpedi.codcia = Ccbcdocu.codcia
            AND Faccpedi.coddiv = Ccbcdocu.coddiv
            AND Faccpedi.coddoc = Ccbcdocu.CodPed
            AND Faccpedi.nroped = Ccbcdocu.NroPed:
            ASSIGN
                Faccpedi.FlgEst = "P".
            /* TRACKING */
            RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                                    Faccpedi.CodDiv,
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    s-User-Id,
                                    'GOD',
                                    'A',
                                    DATETIME(TODAY, MTIME),
                                    DATETIME(TODAY, MTIME),
                                    Faccpedi.CodDoc,
                                    Faccpedi.NroPed,
                                    Faccpedi.CodRef,
                                    Faccpedi.NroRef).
            FOR EACH Facdpedi EXCLUSIVE-LOCK OF Faccpedi:
                ASSIGN Facdpedi.CanAte = 0.
            END.
        END.
        /* Extorna Salida de Almacen */
        RUN vta2/des_alm (ROWID(CcbCDocu)).
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
END.
RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

