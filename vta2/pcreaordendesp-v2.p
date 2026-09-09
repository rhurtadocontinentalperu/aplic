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

DEF INPUT PARAMETER pRowid AS ROWID.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

pMensaje = "".   


DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER B-ADocu FOR CcbADocu.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se ubicó el Pedido".
    RETURN 'ADM-ERROR'.
END.
/* SOLO PARA PEDIDOS APROBADOS */
IF B-CPEDI.FlgEst <> "P" THEN RETURN 'OK'.
/* NO DEBE SER PARA CROSS DOCKING */
IF B-CPEDI.CrossDocking = YES THEN DO:
    pMensaje = "Si es para Cross Docking NO debe generar una ORDEN DE DESPACHO".
    RETURN 'ADM-ERROR'.
END.


DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* NOTA: La división debe ser la de FACCPEDI */
DEF VAR s-CodDiv AS CHAR NO-UNDO.
s-CodDiv = B-CPEDI.CodDiv.
/* ***************************************** */

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.
DEFINE VARIABLE s-DiasVtoO_D LIKE GN-DIVI.DiasVtoO_D.
DEFINE VARIABLE s-NroSer AS INTEGER.

/* PARAMETROS DE COTIZACION PARA LA DIVISION */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = s-coddiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + s-coddiv + ' NO configurada'.
    RETURN 'ADM-ERROR'.
END.

DEF VAR s-coddoc AS CHAR INIT "O/D".

CASE B-CPEDI.CodDoc:
    WHEN "PED" THEN s-CodDoc = "O/D".
    WHEN "P/M" THEN s-CodDoc = "O/M".
END CASE.
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Correlativo del Documento no configurado: " + s-coddoc.
   RETURN 'ADM-ERROR'.
END.
ASSIGN
    s-nroser = FacCorre.NroSer.

ASSIGN
    s-FlgPicking = GN-DIVI.FlgPicking
    s-FlgBarras  = GN-DIVI.FlgBarras
    s-DiasVtoO_D = GN-DIVI.DiasVtoO_D.

FIND FIRST FacCfgGn WHERE FacCfgGn.codcia = s-codcia NO-LOCK.

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
         HEIGHT             = 5.69
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEFINE VAR cEsValeUtilex AS LOG INIT NO.
DEFINE VAR cNroVales AS CHAR.
DEFINE VAR x-Comprobante AS CHAR NO-UNDO.
DEFINE VAR cMsgError AS CHAR NO-UNDO.
DEFINE BUFFER h-faccpedi FOR faccpedi.

cMsgError = "".
SESSION:SET-WAIT-STATE('GENERAL').
LoopGrabarData:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CPEDI THEN DO:
        cMsgError = "No se pudo Bloquear B-CPEDI".
        UNDO LoopGrabarData, LEAVE.
    END.
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion=" FacCorre.CodCia = s-codcia
        AND FacCorre.CodDoc = s-coddoc
        AND FacCorre.NroSer = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Intentos=10
        &Mensaje="NO"
        &txtMensaje="cMsgError"
        &TipoError="UNDO LoopGrabarData, LEAVE LoopGrabarData"
        }
    /* **************************** */
    /* NOTA: el campo Importe[1] e Importe[2] sirven para determinar el redondeo
        Importe[1]: Importe original del pedido
        Importe[2]: Importe del redondeo
        NOTA. El campo TpoLic sirve para controlar cuando se aplica o no un adelanto de campaña
    */
    /* Ic - 29Ene2016, para vales utilex (B-CPEDI : PEDIDO)*/
    /* Busco la cotizacion */
    FIND FIRST h-faccpedi WHERE h-faccpedi.codcia = s-codcia 
        AND h-faccpedi.coddoc = 'COT' 
        AND h-faccpedi.nroped = b-cpedi.nroref NO-LOCK NO-ERROR.
    IF AVAILABLE h-faccpedi THEN DO:
        IF h-faccpedi.tpoped = 'VU' THEN cEsValeUtilex = YES.
    END.

    CREATE FacCPedi.
    BUFFER-COPY B-CPEDI 
        EXCEPT 
        B-CPEDI.TpoPed
        B-CPEDI.FlgEst
        B-CPEDI.FlgSit
        B-CPEDI.TipVta
        TO FacCPedi
        ASSIGN 
            FacCPedi.CodCia = S-CODCIA
            FacCPedi.CodDiv = S-CODDIV
            FacCPedi.CodDoc = s-coddoc 
            FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
            FacCPedi.CodRef = B-CPEDI.CodDoc
            FacCPedi.NroRef = B-CPEDI.NroPed
            FacCPedi.TpoCmb = FacCfgGn.TpoCmb[1] 
            FacCPedi.FchPed = TODAY
            FacCPedi.FchVen = TODAY + s-DiasVtoO_D
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = 'X'   /* PROCESANDO: revisar rutina Genera-Pedido */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        cMsgError = "Correlativo de la Orden mal registrado o duplicado".
        UNDO LoopGrabarData, LEAVE.
    END.
    /* ************************************************************************** */
    /* RHC 22/11/17 se va a volver a calcular la fecha de entrega                 */
    /* ************************************************************************** */
    DEF VAR pFchEnt AS DATE NO-UNDO.
    pFchEnt = FacCPedi.FchEnt.
    RUN logis/p-fecha-de-entrega (INPUT Faccpedi.CodDoc,
                                  INPUT Faccpedi.NroPed,
                                  INPUT-OUTPUT pFchEnt,
                                  OUTPUT cMsgError).
    IF cMsgError > '' THEN DO:
        UNDO LoopGrabarData, LEAVE.
    END.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.  /* OJO */
    /* ************************************************************************** */
    /* ************************************************************************** */
    /* ************************************************************************** */
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
    FIND FIRST Ccbadocu WHERE Ccbadocu.codcia = B-CPEDI.codcia
        AND Ccbadocu.coddiv = B-CPEDI.coddiv
        AND Ccbadocu.coddoc = B-CPEDI.coddoc
        AND Ccbadocu.nrodoc = B-CPEDI.nroped
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
                B-ADOCU.NroDoc = FacCPedi.NroPed
            NO-ERROR.
    END.
    /* ******************************** */
    ASSIGN 
        FacCPedi.UsrAprobacion = S-USER-ID
        FacCPedi.FchAprobacion = TODAY.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK.
    ASSIGN
        s-FlgPicking = GN-DIVI.FlgPicking
        s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pickear en Almacén */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Picking OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */

    /* RHC 08/02/2016 Consolidación de pedidos Expo del almacén 21 en OTR */
    IF B-CPEDI.FlgSit = "O" THEN FacCPedi.FlgSit = "O".   /* Letra "o", no cero */

    /* Ic - 29Ene2016, para vales utilex (B-CPEDI : PEDIDO)*/
    IF (cEsValeUtilex = YES) THEN DO:
        ASSIGN 
            FacCPedi.FlgEst = 'P'
            FacCPedi.FlgSit = 'C' .
    END.

    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (cMsgError > '') THEN
            cMsgError = "No se pudo generar el detalle de la Orden de Despacho".
        UNDO LoopGrabarData, LEAVE.
    END.
    /* ******************************************************************** */
    /* RHC 26/12/2016 Consistencia final: La O/D y el PED deben ser iguales */
    /* ******************************************************************** */
    DEF VAR x-ItmPed AS INT NO-UNDO.
    DEF VAR x-ItmOD  AS INT NO-UNDO.
    DEF VAR x-ImpPed AS DEC NO-UNDO.
    DEF VAR x-ImpOD  AS DEC NO-UNDO.

    ASSIGN
        x-ItmPed = 0
        x-ItmOD  = 0
        x-ImpPed = 0
        x-ImpOD  = 0.
    FOR EACH Facdpedi OF Faccpedi NO-LOCK:
        x-ItmPed = x-ItmPed + 1.
        x-ImpPed = x-ImpPed + Facdpedi.ImpLin.
    END.
    FOR EACH B-DPEDI OF B-CPEDI NO-LOCK:
        x-ItmOD = x-ItmOD + 1.
        x-ImpOD = x-ImpOD + B-DPEDI.ImpLin.
    END.
    IF x-ItmPed <> x-ItmOD OR x-ImpPed <> x-ImpOD THEN DO:
        cMsgError = "Se encontró una inconsistencia entre el Pedido y la Orden de Despacho" +  CHR(10) +
            "Proceso Abortado".        
        UNDO LoopGrabarData, LEAVE.
    END.
    /* ******************************************************************** */
    /* ******************************************************************** */
    RUN Genera-SubPedidos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (cMsgError > '') THEN
            cMsgError = "No se pudo generar el detalle de la Sub-Orden de Despacho".
        UNDO LoopGrabarData, LEAVE.        
    END.
    /* *************************************************************************** */
    /* *************************************************************************** */
    RUN Actualiza-Pedido (+1).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        cMsgError = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO LoopGrabarData, LEAVE.        
    END.

    /* RHC 08/04/2016 Ahora sí actualizamos el estado */
    ASSIGN
        FacCPedi.FlgEst = 'P'.  /* APROBADO */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.

    x-Comprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
END.
SESSION:SET-WAIT-STATE('').
IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
IF AVAILABLE(B-ADOCU)  THEN RELEASE B-ADOCU.
pMensaje = cMsgError.
IF TRUE <> (cMsgError > "") THEN DO:
    pMensaje = 'PROCESO EXITOSO' + CHR(10) + 'Se generó el siguiente documento: ' + x-Comprobante.
    RETURN 'OK'.
END.
ELSE DO:
    RETURN 'ADM-ERROR'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Actualiza-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Actualiza-Pedido Procedure 
PROCEDURE Actualiza-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER X-Tipo AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE I-NRO AS INTEGER INIT 0 NO-UNDO.

  RLOOP:
  FOR EACH FacdPedi OF FaccPedi NO-LOCK ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
      FIND FIRST B-DPedi WHERE B-DPedi.CodCia = B-CPEDI.CodCia 
          AND B-DPedi.CodDiv = B-CPEDI.CodDiv
          AND B-DPedi.CodDoc = B-CPEDI.CodDoc
          AND B-DPedi.NroPed = B-CPEDI.NroPed
          AND B-DPedi.CodMat = FacDPedi.CodMat 
          AND B-DPedi.AlmDes = FacDPedi.AlmDes
          AND B-DPedi.Libre_c05 = FacDPedi.Libre_c05    /* OF: Promocional */
          EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE B-DPEDI THEN DO:
          pMensaje = "NO se pudo actualizar la cantidad atendida en el pedido." + CHR(10) +
              "Producto: " + FacDPedi.CodMat.
          UNDO RLOOP, RETURN 'ADM-ERROR'.
      END.
      ASSIGN
          B-DPEDI.CanAte = B-DPEDI.CanAte + x-Tipo * FacDPedi.CanPed
          B-DPEDI.FlgEst = (IF x-Tipo = +1 THEN "C" ELSE "P").
      IF B-DPEDI.CanAte > B-DPEDI.CanPed THEN DO:
          pMensaje = 'Se ha detectado un error en el producto ' + B-DPEDI.codmat + CHR(10) +
              'Las ordenes superan el pedido' + CHR(10) +
              'Cant. pedida  : ' + STRING(B-DPEDI.CanPed, '->>>,>>9.99') + CHR(10) +
              'Total ordenes : ' + STRING(B-DPEDI.CanAte, '->>>,>>9.99') + CHR(10) +
              'FIN DEL PROCESO'.
          UNDO RLOOP, RETURN "ADM-ERROR".
      END.
  END.
  IF x-Tipo = -1 THEN B-CPedi.FlgEst = "P".
  IF x-Tipo = +1 THEN B-CPedi.FlgEst = "C".

  RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-Pedido Procedure 
PROCEDURE Genera-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


   DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

   FOR EACH B-DPEDI OF B-CPEDI NO-LOCK BY B-DPEDI.NroItm 
       ON ERROR UNDO, RETURN 'ADM-ERROR'
       ON STOP  UNDO, RETURN 'ADM-ERROR':
       /* GRABAMOS LA DIVISION Y EL ALMACEN DESTINO EN LA CABECERA */
       I-NITEM = I-NITEM + 1.
       CREATE FacDPedi. 
       BUFFER-COPY B-DPEDI 
           TO FacDPedi
           ASSIGN  
           FacDPedi.CodCia  = FacCPedi.CodCia 
           FacDPedi.coddiv  = FacCPedi.coddiv 
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
           cMsgError = "Error al grabar el producto " + B-DPEDI.codmat.
           UNDO, RETURN 'ADM-ERROR'.
       END.
   END.
   RETURN 'OK'.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-SubPedidos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-SubPedidos Procedure 
PROCEDURE Genera-SubPedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* SOLO para O/D control de Pickeo */
IF FacCPedi.FlgSit <> "T" THEN RETURN 'OK'.

/* ************************************************************************** */
/* RHC 09/11/2018 NO se generan SubOrdenDespacho (SOD) si es una división GPS */
/* ************************************************************************** */
/* Buscar la división de despacho */
FIND Almacen WHERE Almacen.codcia = s-CodCia AND Almacen.codalm = Faccpedi.CodAlm NO-LOCK.
FIND gn-divi WHERE gn-divi.codcia = s-codcia AND gn-divi.coddiv = Almacen.coddiv NO-LOCK.
IF gn-divi.Campo-Char[9] = "GPS" THEN RETURN 'OK'.
/* ************************************************************************** */
/* ************************************************************************** */

DEFINE VAR lSector AS CHAR.

DEFINE VAR lSectorG0 AS LOG.
DEFINE VAR lSectorOK AS LOG.
DEFINE VAR lUbic AS CHAR.
/* 
    Para aquellos articulos cuya ubicacion no sea correcta SSPPMMN
    SS : Sector
    PP : Pasaje
    MM : Modulo
    N  : Nivel (A,B,C,D,E,F)
*/
lSectorG0 = NO.

/* Los subpedidos se generan de acuerdo al SECTOR donde esten ubicados los productos */
/* El SECTOR forma parte del código de ubicación */
FOR EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
    AND Almmmate.CodAlm = facdpedi.almdes
    AND Almmmate.codmat = facdpedi.codmat
    BREAK BY SUBSTRING(Almmmate.CodUbi,1,2)
    ON ERROR UNDO, RETURN 'ADM-ERROR'
    ON STOP  UNDO, RETURN 'ADM-ERROR':
    IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:

        /* Ic - 29Nov2016, G- = G0 */
        lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
        lUbic = TRIM(Almmmate.CodUbi).
        lSectorOK = NO.
        /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
        IF (lSector >= '01' AND lSector <= '06') AND LENGTH(lUbic) = 7 THEN DO:
            /* Ubic Ok */
            lSectorOK = YES.
        END.
        ELSE DO:
            lSector = "G0".
        END.        
        /* Ic - 29Nov2016, FIN  */
        IF lSectorOK = YES OR lSectorG0 = NO THEN DO:
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
                cMsgError = "Error al grabar la suborden " + faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
                UNDO, RETURN 'ADM-ERROR'.
            END.
            IF lSector = 'G0' THEN lSectorG0 = YES.
        END.
    END.
    CREATE vtaddocu.
    BUFFER-COPY facdpedi TO vtaddocu
        ASSIGN
        VtaDDocu.CodCia = VtaCDocu.codcia
        VtaDDocu.CodDiv = VtaCDocu.coddiv
        VtaDDocu.CodPed = VtaCDocu.codped
        VtaDDocu.NroPed = faccpedi.nroped + '-' + lSector /*VtaCDocu.nroped*/
        VtaDDocu.CodUbi = Almmmate.CodUbi
        VtaDDocu.CanBase = Facdpedi.CanPed.
END.
IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

