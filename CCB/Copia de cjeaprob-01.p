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

DEFINE SHARED VARIABLE S-USER-ID  AS CHAR.
DEFINE SHARED VARIABLE cl-codcia AS INT.

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
         HEIGHT             = 5.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEF VAR f-CodDoc AS CHAR INIT 'A/R' NO-UNDO.
DEF VAR f-ImpAde AS DEC  INIT 0 NO-UNDO.
DEF VAR f-FchDoc AS DATE NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CcbCMvto WHERE ROWID(CcbCMvto) = s-ROWID EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcmvto THEN UNDO, RETURN 'ADM-ERROR'.

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
                    MESSAGE "ERROR en el canje:" Ccbcmvto.coddoc Ccbcmvto.nrodoc SKIP
                        "Las fecha de emisión de las letras son diferentes" SKIP(1)
                        "Este canje NO va a ser aprobado hasta que se corrija el error"
                        VIEW-AS ALERT-BOX ERROR.
                    RETURN 'ADM-ERROR'.
                END.
            END.
            ELSE f-FchDoc = Ccbcdocu.fchdoc.
        END.
    END.

    /* CANJE POR LETRA ADELANTADA */
    IF CcbCMvto.CodDoc = "CLA" THEN DO:
        FIND FIRST FacCorre WHERE FacCorre.CodCia = Ccbcmvto.codcia 
            AND FacCorre.Coddiv = CcbCmvto.coddiv 
            AND FacCorre.CodDoc = f-coddoc 
            AND FacCorre.FlgEst = YES
            EXCLUSIVE-LOCK NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE 'NO está definido el correlativo para la division' Ccbcmvto.coddiv 
                'del documento' f-coddoc
                VIEW-AS ALERT-BOX WARNING.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR':U.
        END.
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
            NO-LOCK.
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
            MESSAGE 'NO se pudo generar el A/R' SKIP
                'Revisar los correlativos' VIEW-AS ALERT-BOX ERROR.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.

        END.
        FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
            AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN  CcbCDocu.NomCli = gn-clie.NomCli.
    END.
    /* ************************** */    
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
        AND CcbDMvto.CodDoc = CcbCMvto.CodDoc 
        AND CcbDMvto.NroDoc = CcbCMvto.NroDoc 
        AND CcbDMvto.TpoRef = "O":
        RUN Cancela-Documento.
        IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.                                                                      

    /* RHC 02/09/17 Actualizar la forma de pago Julissa Calderon */
    /* Se toma el de mayor importe */
    DEF VAR cFmaPgo AS CHAR NO-UNDO.
    DEF VAR fImpTot AS DEC  NO-UNDO.

    cFmaPgo = ''.
    fImpTot = 0.
    FOR EACH CcbDMvto WHERE CcbDMvto.CodCia = CcbCMvto.codcia 
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

    FOR EACH Ccbcdocu WHERE Ccbcdocu.codcia = Ccbcmvto.codcia
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
    IF AVAILABLE(Ccbcdocu) THEN RELEASE Ccbcdocu.
    IF AVAILABLE(Ccbdmvto) THEN RELEASE Ccbdmvto.
    IF AVAILABLE(Ccbdcaja) THEN RELEASE Ccbdcaja.
    IF AVAILABLE(Ccbcmvto) THEN RELEASE CcbCMvto.
    IF AVAILABLE(Faccorre) THEN RELEASE Faccorre.
END.
RETURN 'OK'.

/*
  DEF VAR f-CodDoc AS CHAR INIT 'A/R' NO-UNDO.
  
  FIND CURRENT CcbCMvto EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN RETURN 'ADM-ERROR':U.
  
  FIND FIRST FacCorre WHERE FacCorre.CodCia = s-codcia AND
    FacCorre.Coddiv = CcbCmvto.coddiv AND
    FacCorre.CodDoc = f-coddoc AND
    FacCorre.FlgEst = YES
    EXCLUSIVE-LOCK NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE 'NO está definido el correlativo para la division' Ccbcmvto.coddiv 
          'del documento' f-coddoc
          VIEW-AS ALERT-BOX WARNING.
      RETURN 'ADM-ERROR':U.
  END.

  /* GENERAMOS LAS LETRAS EN LA CUENTA POR COBRAR */
  FOR EACH CcbDMvto NO-LOCK WHERE 
         CcbDMvto.CodCia = CcbCMvto.codcia AND
         CcbDMvto.CodDoc = CcbCMvto.CodDoc AND
         CcbDMvto.NroDoc = CcbCMvto.NroDoc :
    CASE CcbDMvto.TpoRef:
       WHEN 'L' THEN DO:
          CREATE CcbCDocu.
          ASSIGN
              CcbCDocu.CodCia = CcbDMvto.CodCia 
              CcbCDocu.CodDiv = CcbCMvto.CodDiv
              CcbCDocu.CodCli = CcbCMvto.CodCli
              CcbCDocu.CodDoc = CcbDMvto.CodRef 
              CcbCDocu.NroDoc = CcbDMvto.NroRef 
              CcbCDocu.CodMon = CcbCMvto.CodMon 
              CcbCDocu.CodRef = CcbDMvto.CodDoc  
              CcbCDocu.NroRef = CcbDMvto.NroDoc 
              CcbCDocu.FchDoc = CcbDMvto.FchEmi
              CcbCDocu.FchVto = CcbDMvto.FchVto
              CcbCDocu.FchCie = TODAY
              CcbCDocu.FlgEst = 'P'
              CcbCDocu.FlgUbi = 'C'
              CcbCDocu.Glosa  = CcbCMvto.Glosa
              CcbCDocu.ImpTot = CcbDMvto.ImpTot 
              CcbCDocu.SdoAct = CcbDMvto.ImpTot 
              CcbCDocu.TpoCmb = CcbCMvto.TpoCmb
              CcbCDocu.CodDpto = CcbCMvto.CodDpto
              CcbCDocu.CodProv = CcbCMvto.CodProv
              CcbCDocu.CodDist = CcbCMvto.CodDist
              CcbCDocu.usuario= S-USER-ID.
          FIND gn-clie WHERE 
               gn-clie.CodCia = CL-CODCIA AND
               gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
          IF AVAILABLE gn-clie THEN  CcbCDocu.NomCli = gn-clie.NomCli.
        END.
      END CASE.
  END.
  /* GENERAMOS LOS ADELANTOS */
  CREATE CcbCDocu.
  ASSIGN
    CcbCDocu.Codcia = CcbCmvto.codcia
    CcbCDocu.CodDiv = CcbCmvto.coddiv
    CcbCDocu.Coddoc = F-CODDOC
    CcbCDocu.NroDoc = STRING(faccorre.nroser, "999") + STRING(faccorre.correlativo, "999999")
    CcbCDocu.CodCli = CcbCmvto.Codcli
    CcbCDocu.CodRef = CcbCmvto.CodDoc
    CcbCDocu.NroRef = CcbCmvto.NroDoc
    CcbCDocu.FchDoc = TODAY
    CcbCDocu.FchVto = TODAY
    CcbCDocu.CodMon = CcbCmvto.CodMon
    CcbCDocu.Usuario = S-USER-ID            
    CcbCDocu.FlgEst = "P"
    FacCorre.Correlativo = FacCorre.Correlativo + 1
    CcbCDocu.ImpTot = CcbCmvto.ImpTot
    CcbCDocu.SdoAct = CcbCmvto.ImpTot.
  FIND gn-clie WHERE gn-clie.CodCia = CL-CODCIA
    AND gn-clie.CodCli = CcbCDocu.CodCli NO-LOCK NO-ERROR.
  IF AVAILABLE gn-clie THEN  CcbCDocu.NomCli = gn-clie.NomCli.

  RELEASE Ccbcdocu.
  RELEASE faccorre.
  
  /* CIERRE DEL CANJE */
  ASSIGN
    /*CcbCMvto.usuario = s-user-id      */
    CcbCMvto.FchApr = TODAY
    CcbCMvto.FlgEst = 'C'
    CcbCMvto.Libre_chr[10] = s-user-id.

  RELEASE CcbCMvto.
*/

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
    FIND CcbCDocu WHERE CcbCDocu.CodCia = CcbDMvto.CodCia 
        AND CcbCDocu.CodDoc = CcbDMvto.CodRef 
        AND CcbCDocu.NroDoc = CcbDMvto.NroRef EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE Ccbcdocu THEN DO:
        MESSAGE 'NO se pudo cancelar el documento' CcbDMvto.CodRef CcbDMvto.NroRef SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF CcbCDocu.CodMon = CcbCMvto.CodMon THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct - CcbDMvto.ImpTot.
    ELSE DO:
        IF CcbCDocu.CodMon = 1 THEN CcbCDocu.SdoAct = CcbCDocu.SdoAct - (CcbDMvto.ImpTot * CcbCMvto.TpoCmb).
        ELSE CcbCDocu.SdoAct = CcbCDocu.SdoAct - (CcbDMvto.ImpTot / CcbCMvto.TpoCmb).
    END.
    IF Ccbcdocu.SdoAct < 0 THEN DO:
        MESSAGE 'ERROR: El saldo del documento' Ccbcdocu.coddoc Ccbcdocu.nrodoc 'NO puede ser negativo' SKIP
            'Proceso abortado' VIEW-AS ALERT-BOX ERROR.
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

