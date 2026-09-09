&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CDOCU FOR CcbCDocu.



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
DEFINE INPUT PARAMETER s-Descarga-stock-letras AS LOG.      /* Si descarga el Stock de Letras */

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
   Temp-Tables and Buffers:
      TABLE: B-CDOCU B "?" ? INTEGRAL CcbCDocu
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.15
         WIDTH              = 78.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/*  Ic - 18Dic2019, Reunion de condiciones comerciales del 17Oct219, Pto 6.
    Ticket 68717
    DEF VAR f-CodDoc AS CHAR INIT 'A/R' NO-UNDO.
*/
DEF VAR f-CodDoc AS CHAR INIT 'LPA' NO-UNDO.
DEF VAR f-ImpAde AS DEC  INIT 0 NO-UNDO.
DEF VAR f-FchDoc AS DATE NO-UNDO.

DEFINE VAR x-total-canje AS DEC.
DEFINE VAR x-cuantas-letras AS INT.
DEFINE VAR x-conteo AS INT.
DEFINE VAR x-suma AS DEC.
DEFINE VAR x-factor AS DEC.

DEF VAR pMensaje AS CHAR NO-UNDO.

pMensaje = ''.
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
    /* RHC 04/06/2014 CONSISTENCIA ANTES DE APROBAR EL CANJE */
    IF LOOKUP(Ccbcmvto.coddoc, 'CJE,CLA') > 0 THEN DO:      /* Por ahora CJE y CLA */
        /* Verificamos que la fecha de emisión de las letras sean todas iguales */
        f-FchDoc = ?.
        FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
            AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
            AND CcbCDocu.CodDoc = "LET"
            AND CcbCDocu.CodRef = CcbCMvto.CodDoc
            AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:
            IF f-FchDoc <> ? THEN DO:
                /* Comparamos */
                IF Ccbcdocu.fchdoc <> f-FchDoc THEN DO:
                    pMensaje = "ERROR en el canje: " +  Ccbcmvto.coddoc + ' ' + Ccbcmvto.nrodoc + CHR(10) +
                        "Las fecha de emisión de las letras son diferentes" + CHR(10) +
                        "Este canje NO va a ser aprobado hasta que se corrija el error".
                    UNDO PRINCIPAL, LEAVE PRINCIPAL.
                END.
            END.
            ELSE f-FchDoc = Ccbcdocu.fchdoc.
            IF CAN-FIND(FIRST B-CDOCU WHERE B-CDOCU.CodCia = Ccbcdocu.codcia
                        AND B-CDOCU.CodDiv = CcbCMvto.CodDiv
                        AND B-CDOCU.CodDoc = "LET"
                        AND B-CDOCU.CodRef = Ccbcmvto.CodDoc
                        AND B-CDOCU.NroRef = Ccbcmvto.NroDoc
                        AND B-CDOCU.FchVto = Ccbcdocu.FchVto
                        AND ROWID(B-CDOCU) <> ROWID(Ccbcdocu)
                        NO-LOCK) THEN DO:
                pMensaje = "ERROR en el canje: " +  Ccbcmvto.coddoc + ' ' + Ccbcmvto.nrodoc + CHR(10) +
                    "Las fecha de vencimiento de las letras son iguales" + CHR(10) +
                    "Este canje NO va a ser aprobado hasta que se corrija el error".
                UNDO PRINCIPAL, LEAVE PRINCIPAL.
            END.
        END.
    END.

    /* CANJE POR LETRA ADELANTADA */
    IF CcbCMvto.CodDoc = "CLA" THEN DO:
        RUN Canje-Letra-Adelantada.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE PRINCIPAL.
    END.

    /* Ic - 30May2018, Actualiza Stock de letras */
    /* Ic - 27Jul2018, Pregunta si descarga Stock de letras, correo de Julissa */
    IF s-Descarga-stock-letras = YES THEN DO:
        IF LOOKUP(Ccbcmvto.coddoc, 'CJE,CLA,REF') > 0 THEN DO:
            RUN stock-Letras-Adelantada.
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, LEAVE PRINCIPAL.
        END.
    END.

    /* ************************** */    
    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc 
        AND CcbDMvto.TpoRef = "O":

        RUN Cancela-Documento.

        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, LEAVE PRINCIPAL.
    END.                                                                      

    /* Ic - 07Abr2021, TRAZABILIDAD */    

    x-total-canje = CcbCMvto.imptot.
    x-cuantas-letras = 0.

    /* Cuantas Letras */
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc           /* CJE, CLA, REF */
        AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:
                
        x-cuantas-letras = x-cuantas-letras + 1.
    END.

    /* Prorratear cada letra con respecto al total */
    x-conteo = 1.
    x-suma = 0.
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc       /* CJE, CLA, REF */
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
            pMensaje = "El documento " + CcbCDocu.CodDoc + " " + CcbCDocu.NroDoc + CHR(10) + CHR(13) +
                    "No se encuenta o no esta disponible".
            IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
        ASSIGN b-ccbcdocu.libre_d01 = x-factor.
        x-conteo = x-conteo + 1.
        x-suma = x-suma + x-factor.

        /* */
        RUN trazabilidad-letra-Docs(INPUT x-factor, OUTPUT pMensaje).

        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            MESSAGE pMensaje.
            /*
            pMensaje = "El documento " + CcbCDocu.CodDoc + " " + CcbCDocu.NroDoc + CHR(10) + CHR(13) +
                    "Probmeas en trazabilidad-letra-Docs".
            */
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.
            
    END.
    
    IF Ccbcmvto.coddoc = 'CLA' THEN DO:
        /* Por  */
        RUN trazabilidad-letra-cla.

        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "El documento " + CcbCMvto.CodDoc + " " + CcbCMvto.NroDoc + CHR(10) + CHR(13) +
                    "Probmeas en trazabilidad-letra-cla".
            UNDO PRINCIPAL, LEAVE PRINCIPAL.
        END.            
    END.

    /* FIN TRAZABILIDAD */

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

    IF TRUE <> (cFmaPgo > '') THEN cFmaPgo = '403'. /* Anticipos Campaña */

    FOR EACH Ccbcdocu EXCLUSIVE-LOCK WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
        AND Ccbcdocu.coddiv = Ccbcmvto.coddiv
        AND Ccbcdocu.codref = Ccbcmvto.coddoc
        AND Ccbcdocu.nroref = Ccbcmvto.nrodoc:
        ASSIGN
            CcbCDocu.FchCre = TODAY
            CcbCDocu.FlgEst = 'P'   /* Pendiente */
            CcbCDocu.usuario = S-USER-ID
            CcbCDocu.FmaPgo = cFmaPgo.      /* OJO */
        /* NO para Renovación de Letras */
        IF LOOKUP(Ccbcmvto.coddoc, "RNV") = 0 THEN
            ASSIGN
            CcbCDocu.FlgUbi = 'C'   /* Cartera */
            CcbCDocu.FlgSit = 'C'.  /* Cobranza Libre */
    END.                                                   
    ASSIGN
        CcbCMvto.FlgEst = 'E'
        CcbCMvto.FchApr = TODAY
        CcbCMvto.Libre_date[1] = DATETIME(TODAY, MTIME)
        CcbCMvto.Libre_chr[1] = s-user-id.
END.

IF AVAILABLE(b-Ccbcdocu) THEN RELEASE b-Ccbcdocu.
IF AVAILABLE(b-trazabilidad-mov) THEN RELEASE b-trazabilidad-mov.
IF AVAILABLE(trazabilidad-mov) THEN RELEASE trazabilidad-mov.
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

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR' :
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
    /* ******************************************************** */
    /* RHC 13/07/2017 Generacion de A/C para VENTAS ANTICIPADAS */
    /* ******************************************************** */
    IF LOOKUP(Ccbcdocu.CodDoc,'FAC,BOL') > 0 
        AND Ccbcdocu.FlgEst = "C" 
        AND Ccbcdocu.TpoFac = "V"
        THEN DO:
        RUN ccb/p-ctrl-fac-adel ( ROWID(Ccbcdocu), "C" ).
        IF RETURN-VALUE = "ADM-ERROR" THEN UNDO, RETURN "ADM-ERROR".
    END.
    /* ******************************************************** */
    IF CcbCMvto.CodDoc <> "RNV" THEN Ccbcdocu.flgsit = Ccbcdocu.flgsita.     /* <<< OJO <<< */
    /* Grabar el documento como cancelado */
    IF Ccbcdocu.coddoc = "N/C" THEN DO:
        CREATE CCBDMOV.
        ASSIGN
            CCBDMOV.CodCia = CcbCMvto.CodCia
            CCBDMOV.CodDiv = CcbCMvto.CodDiv
            CCBDMOV.CodDoc = CcbCDocu.CodDoc
            CCBDMOV.NroDoc = CcbCDocu.NroDoc
            CCBDMOV.CodRef = CcbCMvto.CodDoc
            CCBDMOV.NroRef = CcbCMvto.NroDoc
            CCBDMOV.CodCli = CcbCDocu.CodCli
            CCBDMOV.FchDoc = TODAY      /*CcbCMvto.FchApr      /* CcbCMvto.FchDoc */*/
            CCBDMOV.HraMov = STRING(TIME,"HH:MM:SS")
            CCBDMOV.CodMon = CcbCMvto.CodMon 
            CCBDMOV.TpoCmb = CcbCMvto.TpoCmb
            CCBDMOV.ImpTot = CcbDMvto.ImpTot 
            CCBDMOV.usuario = s-User-ID.
    END.
    ELSE DO:
        CREATE CcbDCaja.
        ASSIGN
            CcbDCaja.CodCia = CcbCMvto.CodCia 
            CcbDCaja.CodDiv = CcbCMvto.CodDiv
            CcbDCaja.CodDoc = CcbCMvto.CodDoc 
            CcbDCaja.NroDoc = CcbCMvto.NroDoc 
            CcbDCaja.CodCli = CcbCMvto.CodCli
            CcbDCaja.CodMon = CcbCMvto.CodMon 
            CcbDCaja.TpoCmb = CcbCMvto.TpoCmb
            CcbDCaja.FchDoc = TODAY     /*CcbCMvto.FchApr     /* CcbCMvto.FchDoc */*/
            CcbDCaja.ImpTot = CcbDMvto.ImpTot 
            CcbDCaja.CodRef = CcbDMvto.CodRef 
            CcbDCaja.NroRef = CcbDMvto.NroRef. 
    END.
END.
RETURN 'OK'.

END PROCEDURE.

/*
        /* Crea Detalle de la Aplicación */
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

        RELEASE B-CDocu.
        RELEASE Ccbdmov.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Canje-Letra-Adelantada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Canje-Letra-Adelantada Procedure 
PROCEDURE Canje-Letra-Adelantada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FIND FIRST FacCorre WHERE FacCorre.CodCia = Ccbcmvto.codcia 
    AND FacCorre.Coddiv = CcbCmvto.coddiv 
    AND FacCorre.CodDoc = f-coddoc 
    AND FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
    pMensaje = 'NO está definido el correlativo para la division ' + Ccbcmvto.coddiv + CHR(10) +
        'del documento ' + f-coddoc.
    RETURN 'ADM-ERROR':U.
END.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="FacCorre.CodCia = Ccbcmvto.codcia ~
        AND FacCorre.Coddiv = CcbCmvto.coddiv ~
        AND FacCorre.CodDoc = f-coddoc ~
        AND FacCorre.FlgEst = YES"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &TxtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* CALCULAMOS EL IMPORTE TOTAL DEL ADELANTO */
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc
        AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:
        f-ImpAde = f-ImpAde + CcbCDocu.ImpTot.
    END.
    /* GENERAMOS LOS ADELANTOS */
    FIND FIRST B-CDOCU WHERE B-CDOCU.codcia = Ccbcmvto.codcia
        AND B-CDOCU.coddiv = Ccbcmvto.coddiv
        AND B-CDOCU.coddoc = "LET"
        AND B-CDOCU.codref = Ccbcmvto.coddoc
        AND B-CDOCU.nroref = Ccbcmvto.nrodoc
        NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'No existe el documento ' + "LET" + " para " + Ccbcmvto.coddoc + " " + Ccbcmvto.nrodoc + CHR(10) + 
            ERROR-STATUS:GET-MESSAGE(1)  + CHR(10) + 
            'Revisar las LETRAS involucradas en el ' + Ccbcmvto.coddoc.
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.

    CREATE CcbCDocu.
    ASSIGN
        CcbCDocu.Codcia = CcbCmvto.codcia
        CcbCDocu.CodDiv = CcbCmvto.coddiv
        CcbCDocu.Coddoc = F-CODDOC
        CcbCDocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
        CcbCDocu.CodCli = CcbCmvto.Codcli
        CcbCDocu.CodRef = CcbCmvto.CodDoc
        CcbCDocu.NroRef = CcbCmvto.NroDoc
        CcbCDocu.FchDoc = B-CDOCU.fchdoc
        CcbCDocu.FchVto = B-CDOCU.fchdoc
        CcbCDocu.CodMon = CcbCmvto.CodMon
        CcbCDocu.Usuario = S-USER-ID            
        CcbCDocu.FlgEst = "P"
        FacCorre.Correlativo = FacCorre.Correlativo + 1
        CcbCDocu.ImpTot = f-ImpAde
        CcbCDocu.SdoAct = f-ImpAde
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = 'NO se pudo generar el ' + f-coddoc + CHR(10) + 
            ERROR-STATUS:GET-MESSAGE(1)  + CHR(10) + 
            'Revisar los correlativos'.
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    FIND FIRST gn-clie WHERE gn-clie.CodCia = CL-CODCIA
        AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN  CcbCDocu.NomCli = gn-clie.NomCli.
END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stock-Letras-Adelantada) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stock-Letras-Adelantada Procedure 
PROCEDURE stock-Letras-Adelantada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
STOCKLETRAS:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    pMensaje = "". 
 
    /* Todas las letras del canje */
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc
        AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:

        CREATE ccbmovlet.
            ASSIGN ccbmovlet.codcia = CcbCDocu.CodCia
                    ccbmovlet.codclie = ccbcdocu.codcli
                    ccbmovlet.tpomov = 'E'
                    ccbmovlet.coddiv = ccbcdocu.coddiv
                    ccbmovlet.nrodoc = ccbcdocu.nrodoc
                    ccbmovlet.qlet = 1
                    ccbmovlet.fchcrea = NOW
                    ccbmovlet.fchmov = TODAY
                    ccbmovlet.usrcrea = s-user-id 
                    NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            pMensaje = 'NO se pudo crear el registro de MOV letras'. 
            UNDO STOCKLETRAS, RETURN 'ADM-ERROR'.
        END.
        
      /* Stock */
      RUN ccb/recepcion-letras-anticipadas-stock.r(INPUT ccbmovlet.codclie, INPUT ccbmovlet.qlet * -1) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN DO:
          pMensaje = 'NO se pudo actualizar los STOCKS de las letras' .
          UNDO STOCKLETRAS, RETURN 'ADM-ERROR'.
      END.

    END.
END.

RETURN 'OK'.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-letra-cla) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-letra-cla Procedure 
PROCEDURE trazabilidad-letra-cla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VAR x-impte-origen AS DEC.

/* Se ejecutar por cada Letra */
/*DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.*/

TRAZABILIDAD:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    /* Cuantas Letras */
    FOR EACH CcbCDocu WHERE CcbCDocu.CodCia = CcbCMvto.CodCia
        AND CcbCDocu.CodDiv = CcbCMvto.CodDiv
        AND CcbCDocu.CodDoc = "LET"
        AND CcbCDocu.CodRef = CcbCMvto.CodDoc           /* CJE, CLA, REF */
        AND CcbCDocu.NroRef = CcbCMvto.NroDoc NO-LOCK:
                
        CREATE b-trazabilidad-mov.
        ASSIGN  b-trazabilidad-mov.codcia = s-codcia
                b-trazabilidad-mov.coddoc = ccbcdocu.coddoc      /* LET */
                b-trazabilidad-mov.nrodoc = ccbcdocu.nrodoc
                b-trazabilidad-mov.codcmpte = ccbcdocu.coddoc   /* LET */
                b-trazabilidad-mov.nrocmpte = ccbcdocu.nrodoc
                b-trazabilidad-mov.impcalculado = ccbcdocu.imptot
                b-trazabilidad-mov.imporigen = ccbcdocu.imptot
                b-trazabilidad-mov.codref = ""
                b-trazabilidad-mov.nroref = ""
                b-trazabilidad-mov.codmov = CcbCMvto.CodDoc     /* CLA */
                b-trazabilidad-mov.nromov = CcbCMvto.nroDoc
                b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                b-trazabilidad-mov.fchcrea = TODAY
                b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
        END.

    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trazabilidad-letra-Docs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trazabilidad-letra-Docs Procedure 
PROCEDURE trazabilidad-letra-Docs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETE pFactor AS DEC.
DEFINE OUTPUT PARAMETER pMsg AS CHAR.

DEFINE VAR x-impte-origen AS DEC.

/* Se ejecutar por cada Letra */
/*DEFINE BUFFER z-ccbcdocu FOR ccbcdocu.*/

pMsg = "".

TRAZABILIDAD:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':

    /* Elimino si existe */
    FOR EACH trazabilidad-mov WHERE trazabilidad-mov.codcia = s-codcia AND
                                    trazabilidad-mov.coddoc = ccbcdocu.coddoc AND /* LET */
                                    trazabilidad-mov.nrodoc = ccbcdocu.nrodoc NO-LOCK:
        FIND FIRST b-trazabilidad-mov WHERE ROWID(trazabilidad-mov) = ROWID(b-trazabilidad-mov)
                                        EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE b-trazabilidad-mov THEN DO:
            DELETE b-trazabilidad-mov.
        END.        
    END.

    FOR EACH CcbDMvto NO-LOCK WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc       /* CJE, CLA, REF */
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc 
        AND CcbDMvto.TpoRef = "O":
    
        /* Monto del Cmpte */
        IF ccbdmvto.codref = 'LET'  THEN DO:
            /* Al parecer es un refinanciamento, se dijo que por canje no sucederia....en fin x siaca */
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
                        b-trazabilidad-mov.codmov = CcbCMvto.CodDoc     /* CJE REF */
                        b-trazabilidad-mov.nromov = CcbCMvto.nroDoc
                        b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                        b-trazabilidad-mov.fchcrea = TODAY
                        b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                        NO-ERROR.
                IF ERROR-STATUS:ERROR THEN DO:
                    pMsg = "ERROR trazabilidad-letra-docs: " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + CHR(10) + CHR(13) +
                            "Comprobante :" + trazabilidad-mov.codcmpte + " " + trazabilidad-mov.nrocmpte + CHR(10) + CHR(13) +
                            "MSG : " + ERROR-STATUS:GET-MESSAGE(1).

                    UNDO TRAZABILIDAD, RETURN 'ADM-ERROR'.
                END.
            END.
        END.
        ELSE DO:
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
                    b-trazabilidad-mov.codmov = CcbCMvto.CodDoc     /* CJE, REF */
                    b-trazabilidad-mov.nromov = CcbCMvto.nroDoc
                    b-trazabilidad-mov.usrcrea = USERID("DICTDB")
                    b-trazabilidad-mov.fchcrea = TODAY
                    b-trazabilidad-mov.horacrea = STRING(TIME,"HH:MM:SS")
                    NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMsg = "ERROR trazabilidad-letra-docs: " + ccbcdocu.coddoc + " " + ccbcdocu.nrodoc + CHR(10) + CHR(13) +
                        "Comprobante :" + CcbDMvto.codref + " " + CcbDMvto.nroref + CHR(10) + CHR(13) +
                        "MSG : " + ERROR-STATUS:GET-MESSAGE(1).
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

