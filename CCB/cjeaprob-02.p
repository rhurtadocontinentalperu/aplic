&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE INPUT PARAMETER s-ROWID AS ROWID.

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE cl-codcia AS INT.
DEFINE SHARED VARIABLE s-codcia AS INT.

DEFINE BUFFER b-ccbcdocu FOR ccbcdocu.
DEFINE BUFFER b-trazabilidad-mov FOR trazabilidad-mov.
DEFINE BUFFER x-ccbcdocu FOR ccbcdocu.

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
         HEIGHT             = 5.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR f-CodDoc AS CHAR INIT 'A/R' NO-UNDO.
DEF VAR pMensaje AS CHAR NO-UNDO.

DEFINE VAR x-total-canje AS DEC.
DEFINE VAR x-cuantas-letras AS INT.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-suma AS DEC. 
DEFINE VAR x-factor AS DEC.


PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="Ccbcmvto"
        &Condicion="ROWID(CcbCMvto) = s-ROWID"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="YES"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* ************************** */    
    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc 
        AND CcbDMvto.TpoRef = "O":

        RUN Cancela-Documento.

        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            IF TRUE <> (pMensaje > '') THEN pMensaje = "NO se pudo cancelar los documentos referenciados".
            UNDO PRINCIPAL, LEAVE.
        END.
    END.                                                                      

    /* RHC 02/09/17 Actualizar la forma de pago Julissa Calderon */
    /* Se toma el de mayor importe */
    DEF VAR cFmaPgo AS CHAR NO-UNDO.
    DEF VAR fImpTot AS DEC  NO-UNDO.
    
    cFmaPgo = ''.
    fImpTot = 0.
    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc 
        AND CcbDMvto.TpoRef = "O",
        FIRST Ccbcdocu NO-LOCK WHERE CcbCDocu.CodCia = CcbDMvto.CodCia
        AND CcbCDocu.CodDoc = CcbDMvto.CodRef
        AND CcbCDocu.NroDoc = CcbDMvto.NroRef:
        IF CcbCDocu.FmaPgo > '' AND CcbCDocu.ImpTot > fImpTot THEN DO:
            fImpTot = CcbCDocu.ImpTot.
            cFmaPgo = CcbCDocu.FmaPgo.
        END.
    END.                                                                      

    /**/
    /* Ic - 07Abr2021, TRAZABILIDAD */    

    x-total-canje = CcbCMvto.imptot.
    x-cuantas-letras = 0.

    /* Cuantas Letras */
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc
        AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:
                
        x-cuantas-letras = x-cuantas-letras + 1.
    END.

    /* Prorratear cada letra con respecto al total */
    x-conteo = 1.
    x-suma = 0.
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc
        AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:
                
        IF x-conteo = x-cuantas-letras THEN DO:
            x-factor = 100 - x-suma.
        END.
        ELSE DO:
            x-factor = ROUND((ccbcdocu.imptot / x-total-canje) * 100,4).
        END.
        
        FIND FIRST b-ccbcdocu WHERE ROWID(b-ccbcdocu) = ROWID(ccbcdocu) EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-ccbcdocu THEN DO:
            /* ERROR */
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        ASSIGN b-ccbcdocu.libre_d01 = x-factor.
        x-conteo = x-conteo + 1.
        x-suma = x-suma + x-factor.

        /* */
        pMensaje = "".
        RUN trazabilidad-letra-Docs(INPUT x-factor).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            /*pMensaje = "Hubo problemas en el procedimiento 'trazabilidad-letra-Docs' en las renovaciones".*/
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
            
    END.

    /* FIN TRAZABILIDAD */    

    FOR EACH Ccbcdocu EXCLUSIVE-LOCK WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
        AND Ccbcdocu.coddiv = Ccbcmvto.coddiv
        AND Ccbcdocu.coddoc = "LET"
        AND Ccbcdocu.codref = Ccbcmvto.coddoc
        AND Ccbcdocu.nroref = Ccbcmvto.nrodoc ON ERROR UNDO, THROW:
        ASSIGN
            CcbCDocu.FchCre = TODAY
            CcbCDocu.FlgEst = 'P'   /* Pendiente */
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.FmaPgo = cFmaPgo.      /* OJO */
    END.                                                   
    ASSIGN
        CcbCMvto.FlgEst = 'E'
        CcbCMvto.FchApr = TODAY
        CcbCMvto.Libre_date[1] = DATETIME(TODAY, MTIME)
        CcbCMvto.Libre_chr[1] = s-user-id.
END.
RELEASE b-trazabilidad-mov NO-ERROR.
IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
IF AVAILABLE(Ccbdmvto) THEN RELEASE Ccbdmvto.
IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.
IF AVAILABLE(Ccbcmvto) THEN RELEASE CcbCMvto.
IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
IF pMensaje > '' THEN DO:
    MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.
    RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Cancela-Documento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Cancela-Documento Procedure 
PROCEDURE Cancela-Documento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="Ccbcdocu"
        &Condicion="CcbCDocu.CodCia = CcbDMvto.CodCia ~
        AND CcbCDocu.CodDoc = CcbDMvto.CodRef ~
        AND CcbCDocu.NroDoc = CcbDMvto.NroRef"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CcbDMvto.ImpTot.
    ELSE DO:
        IF CcbCDocu.CodMon = 1 THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct - (CcbDMvto.ImpTot * CcbCMvto.TpoCmb).
        ELSE CcbCDocu.SdoAct = CcbCDocu.SdoAct - (CcbDMvto.ImpTot / CcbCMvto.TpoCmb).
    END.
    IF Ccbcdocu.SdoAct < 0 THEN DO:
        pMensaje = 'ERROR: El saldo del documento ' + Ccbcdocu.coddoc + ' ' + Ccbcdocu.nrodoc + 
            ' NO puede ser negativo' + CHR(10)  + 'Proceso abortado'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        CcbCDocu.FlgEst = (IF CcbCDocu.SdoAct <= 0 THEN 'C' ELSE CcbCDocu.FlgEst).
    IF CcbCDocu.SdoAct <= 0 THEN ccbcdocu.fchcan = TODAY.
    /* Grabar el documento como cancelado */
    CREATE CcbDCaja.
    ASSIGN
        CcbDCaja.CodCia = CcbCMvto.CodCia 
        CcbDCaja.CodDiv = CcbCMvto.CodDiv
        CcbDCaja.CodDoc = CcbCMvto.CodDoc 
        CcbDCaja.NroDoc = CcbCMvto.NroDoc 
        CcbDCaja.CodCli = CcbCMvto.CodCli
        CcbDCaja.CodMon = CcbCMvto.CodMon 
        CcbDCaja.TpoCmb = CcbCMvto.TpoCmb
        CcbDCaja.FchDoc = TODAY           /* CcbCMvto.FchDoc */
        CcbDCaja.ImpTot = CcbDMvto.ImpTot 
        CcbDCaja.CodRef = CcbDMvto.CodRef 
        CcbDCaja.NroRef = CcbDMvto.NroRef. 
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-letra-docs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-letra-docs Procedure 
PROCEDURE trazabilidad-letra-docs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETE pFactor AS DEC.

DEFINE VAR x-impte-origen AS DEC.
DEFINE VAR x-impte-nuevo AS DEC.

/* Se ejecutar por cada Letra */
/*DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.*/

TRAZABILIDAD:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    /* Elimino si existe x siacaso */
    FOR EACH trazabilidad-mov WHERE trazabilidad-mov.codcia = s-codcia AND
                                    trazabilidad-mov.coddoc = ccbcdocu.coddoc AND /* LET */
                                    trazabilidad-mov.nrodoc = ccbcdocu.nrodoc NO-LOCK:
        FIND FIRST b-trazabilidad-mov WHERE ROWID(trazabilidad-mov) = ROWID(b-trazabilidad-mov)
                                        EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b-trazabilidad-mov THEN DO:
            DELETE b-trazabilidad-mov NO-ERROR.
            IF ERROR-STATUS:ERROR = YES THEN DO:
                pMensaje = "No se pudo eliminar la trazabilidad anterior existente" + CHR(10) + CHR(13) +
                            "de " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc.
                UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
            END.
        END.        
    END.

    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc 
        AND CcbDMvto.TpoRef = "O":
    
        /* Monto del Cmpte */
        IF ccbdmvto.codref = 'LET'  THEN DO:

            /* Debo encontrar el importe de la letra anterior que se uso para renovarla */
            IF CcbCMvto.CodDoc = 'RNV' THEN DO:
                FIND FIRST x-ccbcdocu WHERE x-ccbcdocu.codcia = s-codcia AND
                                                x-ccbcdocu.coddoc = CcbDMvto.codref  AND     /* LET */
                                                x-ccbcdocu.nrodoc = CcbDMvto.nroref NO-LOCK NO-ERROR.
                IF NOT AVAILABLE x-ccbcdocu THEN DO:
                    pMensaje = "No se pudo ubicar el documento anterior " + CcbDMvto.codref + " " + CcbDMvto.nroref.
                    UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
                END.
                x-impte-origen = x-ccbcdocu.imptot.     /* El importe de la letra anterior */
                x-impte-nuevo = ccbdmvto.imptot.        /* El importe de la nueva letra siempre debe ser menor igual a la anterior */

                x-factor = ROUND(x-impte-nuevo / x-ccbcdocu.imptot * 100, 4).   /* El factor x cuanto se renovo, digamos al 60% , 80% */
                pFactor = x-factor.
            END.

            FOR EACH trazabilidad-mov WHERE trazabilidad-mov.codcia = s-codcia AND
                                            trazabilidad-mov.coddoc = CcbDMvto.codref AND     /* LET */
                                                trazabilidad-mov.nrodoc = CcbDMvto.nroref NO-LOCK:

                x-impte-origen = trazabilidad-mov.impcalculado.

                CREATE b-trazabilidad-mov.
                ASSIGN  b-trazabilidad-mov.codcia = s-codcia
                        b-trazabilidad-mov.coddoc = ccbcdocu.coddoc      /* LET */
                        b-trazabilidad-mov.nrodoc = ccbcdocu.nrodoc
                        b-trazabilidad-mov.codcmpte = trazabilidad-mov.codcmpte   /* FAC,BOL,... */
                        b-trazabilidad-mov.nrocmpte = trazabilidad-mov.nrocmpte
                        b-trazabilidad-mov.impcalculado = ROUND((pFactor * x-impte-origen / 100),2)
                        b-trazabilidad-mov.imporigen = x-impte-origen
                        b-trazabilidad-mov.codref = CcbDMvto.codref     /* LET */
                        b-trazabilidad-mov.nroref = CcbDMvto.nroref
                        b-trazabilidad-mov.codmov = CcbCMvto.CodDoc     /* RNV CJE REF */
                        b-trazabilidad-mov.nromov = CcbCMvto.nroDoc
                        b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                        b-trazabilidad-mov.fchcrea = TODAY
                        b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                        NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    pMensaje = "A.- No se puedo crear el registro para :" + CHR(10) + CHR(13) +
                    ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " y " + trazabilidad-mov.codcmpte + " " + trazabilidad-mov.nrocmpte.
                    UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
                END.
            END.
        END.
        ELSE DO:

            /* En teoria en una renovacion no deberia entrar aca x que x renovacion no hay otro documento que sea letra */

            x-impte-origen = CcbDMvto.imptot.
        
            CREATE b-trazabilidad-mov.
            ASSIGN  b-trazabilidad-mov.codcia = s-codcia
                    b-trazabilidad-mov.coddoc = ccbcdocu.coddoc      /* LET */
                    b-trazabilidad-mov.nrodoc = ccbcdocu.nrodoc
                    b-trazabilidad-mov.codcmpte = CcbDMvto.codref   /* FAC,BOL,... */
                    b-trazabilidad-mov.nrocmpte = CcbDMvto.nroref
                    b-trazabilidad-mov.impcalculado = ROUND((pFactor * x-impte-origen / 100),2)
                    b-trazabilidad-mov.imporigen = x-impte-origen
                    b-trazabilidad-mov.codref = ""
                    b-trazabilidad-mov.nroref = ""
                    b-trazabilidad-mov.codmov = CcbCMvto.CodDoc     /* RNV CJE, REF */
                    b-trazabilidad-mov.nromov = CcbCMvto.nroDoc
                    b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                    b-trazabilidad-mov.fchcrea = TODAY
                    b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                    NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "B.- No se puedo crear el registro para :" + CHR(10) + CHR(13) +
                ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + " y " + CcbDMvto.codref + " " + CcbDMvto.nroref.
                UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
            END.
        END.
    END.                                                                      
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

