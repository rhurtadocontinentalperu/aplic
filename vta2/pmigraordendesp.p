&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-CPEDI FOR FacCPedi.
DEFINE BUFFER CMOV FOR Almcmov.



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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR.

pMensaje = "".

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER B-ADocu FOR CcbADocu.
DEF BUFFER PEDIDO  FOR Faccpedi.
DEF BUFFER B-Vtaddocu FOR Vtaddocu.
DEF BUFFER B-ControlOD FOR ControlOD.
DEF BUFFER B-CcbCBult FOR CcbCBult.

/* el INGRESO por transferencia */
FIND Almcmov WHERE ROWID(Almcmov) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almcmov THEN DO:
    pMensaje = "NO se pudo ubicar el Ingreso por Transferencia".
    RETURN 'ADM-ERROR'.
END.

DEF VAR I-MOVORI AS INTEGER NO-UNDO.

FIND FIRST Almtmovm WHERE Almtmovm.CodCia = Almcmov.codcia
    AND  Almtmovm.Tipmov = "S" 
    AND  Almtmovm.MovTrf 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almtmovm THEN DO:
    pMensaje = "NO está configurado el movimiento por Transferencia".
    RETURN 'ADM-ERROR'.
END.
I-MOVORI = Almtmovm.CodMov.
/* la SALIDA por transferencia */
FIND CMOV WHERE CMOV.CodCia = Almcmov.CodCia 
    AND CMOV.CodAlm = Almcmov.AlmDes
    AND CMOV.TipMov = "S" 
    AND CMOV.CodMov = I-MOVORI 
    AND CMOV.NroSer = INTEGER(SUBSTRING(Almcmov.NroRf1,1,3)) 
    AND CMOV.NroDoc = INTEGER(SUBSTRING(Almcmov.NroRf1,4)) 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE CMOV THEN DO:
    pMensaje = "NO se pudo ubicar la Salida por Transferencia " + Almcmov.NroRf1.
    RETURN 'ADM-ERROR'.
END.
/* NOTA: La división debe ser la del Almacén Receptor */
DEF VAR s-CodDiv AS CHAR NO-UNDO.
FIND FIRST Almacen WHERE Almacen.codcia = Almcmov.codcia
    AND Almacen.codalm = Almcmov.codalm
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = "NO se ubicó el almacén " + Almcmov.codalm.
    RETURN 'ADM-ERROR'.
END.
s-CodDiv = Almacen.CodDiv.
/* ************************************************ */

/* la ORDEN DE TRANSFERENCIA: Su origen es un PEDido*/
FIND B-CPEDI WHERE B-CPEDI.codcia = CMOV.codcia
    AND B-CPEDI.coddoc = CMOV.codref   /* OTR */
    AND B-CPEDI.nroped = CMOV.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI OR B-CPEDI.CodRef <> "PED" THEN DO:
    pMensaje = "NO se ubicó la Orden de Transferencia " + CMOV.CodRef + ' ' + CMOV.NroRef.
    RETURN 'ADM-ERROR'.
END.
FIND PEDIDO WHERE PEDIDO.codcia = B-CPEDI.codcia
    AND PEDIDO.coddoc = B-CPEDI.codref
    AND PEDIDO.nroped = B-CPEDI.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE PEDIDO THEN DO:
    pMensaje = "NO se ubicó el PEDIDO origen " + B-CPEDI.codref + ' ' + B-CPEDI.nroref.
    RETURN 'ADM-ERROR'.
END.

DEFINE VARIABLE s-coddoc AS CHAR INIT "O/D".
DEFINE VARIABLE s-NroSer AS INT.

/* SOLO SE PUEDE MIGRAR UNA VEZ */
IF CAN-FIND(FIRST Faccpedi WHERE Faccpedi.codcia = s-codcia
            AND Faccpedi.coddiv = PEDIDO.coddiv     /*s-coddiv*/
            AND Faccpedi.coddoc = s-coddoc
            AND Faccpedi.codref = PEDIDO.coddoc
            AND Faccpedi.nroref = PEDIDO.nroped
            AND Faccpedi.flgest <> "A"
            NO-LOCK) THEN RETURN 'OK'.

FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Correlativo del Documento no configurado: " + s-coddoc + CHR(10) +
       "en la división: " + s-CodDiv.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.

FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje =  'División ' + s-coddiv + ' NO configurada'.
    RETURN 'ADM-ERROR'.
END.
s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.

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
      TABLE: B-CPEDI B "?" ? INTEGRAL FacCPedi
      TABLE: CMOV B "?" ? INTEGRAL Almcmov
   END-TABLES.
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
DEFINE VAR x-Comprobante AS CHAR NO-UNDO.

DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* Creamos la Orden de Despacho en la división que recepciona la Transferencia */
    {vtagn/i-faccorre-01.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE FacCPedi.
    BUFFER-COPY PEDIDO      /* OJO >>> Del PEDIDO original */
        EXCEPT 
        PEDIDO.TpoPed
        PEDIDO.FlgEst
        PEDIDO.FlgSit
        TO FacCPedi
        ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = PEDIDO.CodDiv     /* S-CODDIV */ /* De donde viene */
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodAlm = Almcmov.CodAlm    /* El Almacén Destino */
            FacCPedi.DivDes = s-CodDiv
            FacCPedi.CodRef = PEDIDO.CodDoc
            FacCPedi.NroRef = PEDIDO.NroPed
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.FchPed = TODAY
            FacCPedi.FchVen = TODAY + s-DiasVtoO_D
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = 'X'   /* PROCESANDO: revisar rutina Genera-Pedido */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        pMensaje = "Correlativo de la Orden de Despacho mal registrado o duplicado".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* Ic - 24Feb2016, la fecha de entrega de la O/D debe ser >= fecha de emision */
    IF faccpedi.fchent < faccpedi.fchped THEN ASSIGN faccpedi.fchent = faccpedi.fchped.

    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                              Faccpedi.CodDiv,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef,
                              s-User-Id,
                              'GOD',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Faccpedi.CodDoc,
                              Faccpedi.NroPed,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef)
        NO-ERROR.
    /* COPIAMOS DATOS DEL TRANSPORTISTA */
    FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = PEDIDO.codcia
        AND Ccbadocu.coddiv = PEDIDO.coddiv
        AND Ccbadocu.coddoc = PEDIDO.coddoc
        AND Ccbadocu.nrodoc = PEDIDO.nroped
        NO-LOCK NO-ERROR.
    IF AVAILABLE Ccbadocu THEN DO:
        FIND FIRST B-ADOCU WHERE B-ADOCU.codcia = Faccpedi.codcia
            AND B-ADOCU.coddiv = Faccpedi.coddiv
            AND B-ADOCU.coddoc = Faccpedi.coddoc
            AND B-ADOCU.nrodoc = Faccpedi.nroped
            EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE B-ADOCU THEN CREATE B-ADOCU.
        BUFFER-COPY Ccbadocu TO B-ADOCU
            ASSIGN
                B-ADOCU.CodDiv = FacCPedi.CodDiv
                B-ADOCU.CodDoc = FacCPedi.CodDoc
                B-ADOCU.NroDoc = FacCPedi.NroPed.
    END.
    /* ******************************** */
    /* *************************************************************** */
    /* RHC 21/11/2016 DATOS DEL CIERRE DE LA OTR EN LA DIVISION ORIGEN */
    /* *************************************************************** */
    FOR EACH Vtaddocu NO-LOCK WHERE VtaDDocu.CodCia = B-CPEDI.CodCia
        AND VtaDDocu.CodDiv = B-CPEDI.CodDiv
        AND VtaDDocu.CodPed = B-CPEDI.CodDoc
        AND VtaDDocu.NroPed = B-CPEDI.NroPed:
        CREATE B-Vtaddocu.
        BUFFER-COPY Vtaddocu TO B-Vtaddocu
            ASSIGN 
            B-Vtaddocu.CodDiv = s-CodDiv
            B-Vtaddocu.CodPed = Faccpedi.CodDoc
            B-Vtaddocu.NroPed = Faccpedi.NroPed
            NO-ERROR.
    END.
    FOR EACH ControlOD NO-LOCK WHERE ControlOD.CodCia = B-CPEDI.CodCia
        AND ControlOD.CodDiv = B-CPEDI.CodDiv
        AND ControlOD.CodDoc = B-CPEDI.CodDoc
        AND ControlOD.NroDoc = B-CPEDI.NroPed:
        CREATE B-ControlOD.
        BUFFER-COPY ControlOD TO B-ControlOD
            ASSIGN
            B-ControlOD.CodDiv = s-CodDiv
            B-ControlOD.CodDoc = Faccpedi.CodDoc
            B-ControlOD.NroDoc = Faccpedi.NroPed
            NO-ERROR.
    END.
    FOR EACH CcbCBult NO-LOCK WHERE CcbCBult.CodCia = B-CPEDI.CodCia
        AND CcbCBult.CodDiv = B-CPEDI.CodDiv
        AND CcbCBult.CodDoc = B-CPEDI.CodDoc
        AND CcbCBult.NroDoc = B-CPEDI.NroPed:
        CREATE B-CcbCBult.
        BUFFER-COPY CcbCBult TO B-CcbCBult
            ASSIGN
            B-CcbCBult.CodDiv = s-CodDiv
            B-CcbCBult.CodDoc = Faccpedi.CodDoc
            B-CcbCBult.NroDoc = Faccpedi.NroPed
            NO-ERROR.
    END.
    /* *************************************************************** */
    /* *************************************************************** */
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    ASSIGN 
        FacCPedi.FlgEst = 'P'
        FacCPedi.FlgSit = 'C'.      /* DIRECTO A DISTRIBUCION */

    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "No se pudo generar el detalle de la Orden de Despacho".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    x-Comprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
END.
MESSAGE 'Proceso Terminado' SKIP
    'Se generó el siguiente documento:' x-Comprobante
    VIEW-AS ALERT-BOX INFORMATION.

IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH B-DPEDI OF B-CPEDI NO-LOCK BY B-DPEDI.NroItm:
       /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       BUFFER-COPY B-DPEDI 
           TO FacDPedi
           ASSIGN  
           FacDPedi.CodCia  = FacCPedi.CodCia 
           FacDPedi.coddiv  = FacCPedi.coddiv 
           FacDPedi.AlmDes  = FacCPedi.CodAlm
           FacDPedi.coddoc  = FacCPedi.coddoc 
           FacDPedi.NroPed  = FacCPedi.NroPed 
           FacDPedi.FchPed  = FacCPedi.FchPed
           FacDPedi.Hora    = FacCPedi.Hora 
           FacDPedi.FlgEst  = 'P'       /*FacCPedi.FlgEst*/
           FacDPedi.NroItm  = I-NITEM
           FacDPedi.CanAte  = 0                     /* <<< OJO <<< */
           FacDPedi.CanSol  = FacDPedi.CanPed       /* <<< OJO <<< */
           FacDPedi.CanPick = FacDPedi.CanPed      /* <<< OJO <<< */
           NO-ERROR.
       IF ERROR-STATUS:ERROR THEN DO:
           pMensaje = "Error al grabar el producto " + B-DPEDI.codmat.
           UNDO, RETURN 'ADM-ERROR'.
       END.
   END.
   RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

