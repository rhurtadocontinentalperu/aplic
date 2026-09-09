&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER B-Almacen FOR Almacen.



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

DEF BUFFER B-CPEDI FOR Faccpedi.
DEF BUFFER B-DPEDI FOR Facdpedi.
DEF BUFFER COTIZACION FOR Faccpedi.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se ubicó el Pedido".
    RETURN 'ADM-ERROR'.
END.
IF B-CPEDI.FlgEst <> "P" THEN RETURN 'OK'.
FIND COTIZACION WHERE COTIZACION.codcia = B-CPEDI.codcia
    AND COTIZACION.coddiv = B-CPEDI.coddiv
    AND COTIZACION.coddoc = B-CPEDI.codref
    AND COTIZACION.nroped = B-CPEDI.nroref
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN DO:
    pMensaje = "NO se ubicó la Cotización".
    RETURN 'ADM-ERROR'.
END.

DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

/* NOTA: La división debe ser del ALMACEN DE SALIDA */
DEF VAR s-CodDiv AS CHAR NO-UNDO.

FIND FIRST VtaTabla WHERE VtaTabla.CodCia = COTIZACION.codcia
    AND VtaTabla.Tabla = 'EXPOCOT'
    AND VtaTabla.Llave_c1 = COTIZACION.libre_c01
    AND VtaTabla.Llave_c2 = COTIZACION.coddoc
    AND VtaTabla.LLave_c3 = COTIZACION.nroped
    AND VtaTabla.Llave_c4 = COTIZACION.coddiv 
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE VtaTabla OR (VtaTabla.Llave_c5 = '' OR VtaTabla.Llave_c6 = '')
    THEN DO:
    pMensaje = 'NO configurado los almacenes de salida y/o destino'.
    RETURN 'ADM-ERROR'.
END.
FIND Almacen WHERE Almacen.codcia = B-CPEDI.codcia AND Almacen.codalm = B-CPEDI.codalm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = 'Almacén de despacho ' + B-CPEDI.codalm + ' NO registrado'.
    RETURN 'ADM-ERROR'.
END.
s-CodDiv = Almacen.CodDiv.
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

DEF VAR s-coddoc AS CHAR INIT "OTR".    /* OJO : ORDEN DE TRANSFERENCIA */

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

IF B-CPEDI.FchEnt < TODAY THEN DO:
    pMensaje = 'La fecha de entrega del pedido es el ' + STRING(B-CPEDI.FchEnt) + CHR(10) +
        'Debe corregirlo' + CHR(10) + CHR(10) + 
        'Proceso Abortado'.
    RETURN 'ADM-ERROR'.
END.

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
      TABLE: B-Almacen B "?" ? INTEGRAL Almacen
   END-TABLES.
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
DEFINE VAR x-Comprobante AS CHAR NO-UNDO.

DEFINE VAR lMensaje AS CHAR NO-UNDO.

lMensaje = "".

/*DO TRANSACTION ON ERROR UNDO, RETURN "ADM-ERROR" ON STOP UNDO, RETURN "ADM-ERROR":*/

LoopGrabarData:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :

    FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CPEDI THEN DO:
        /*UNDO, RETURN 'ADM-ERROR'.*/
        lMensaje = "No se pudo Bloquear B-CPEDI".
        UNDO LoopGrabarData, LEAVE.
    END.
    /* Bloqueamos el correlativo para controlar las actualizaciones multiusaurio */
    DEF VAR iLocalCounter AS INTEGER INITIAL 0 NO-UNDO.
    GetLock:
    DO ON STOP UNDO GetLock, RETRY GetLock:
        IF RETRY THEN DO:
            iLocalCounter = iLocalCounter + 1.
            IF iLocalCounter = 5 THEN LEAVE GetLock.
        END.
        FIND FacCorre WHERE FacCorre.CodCia = s-CodCia AND
            FacCorre.CodDoc = s-coddoc AND
            FacCorre.NroSer = s-nroser EXCLUSIVE-LOCK NO-ERROR.
    END.
    /*IF iLocalCounter = 5 OR NOT AVAILABLE FacCorre THEN UNDO, RETURN "ADM-ERROR".*/
    IF iLocalCounter = 5 OR NOT AVAILABLE FacCorre THEN DO:
        lMensaje = "No se pudo Bloquear FacCorre".
        UNDO LoopGrabarData, LEAVE.
    END.       

    {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

    CREATE FacCPedi.
    BUFFER-COPY B-CPEDI 
        EXCEPT 
        B-CPEDI.TpoPed
        B-CPEDI.FlgEst
        B-CPEDI.FlgSit
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
            FacCPedi.FchVen = TODAY + 7
            FacCPedi.Hora = STRING(TIME,"HH:MM")
            FacCPedi.FlgEst = "P"       /* APROBADO */
            FacCPedi.TpoPed = ""
            FacCPedi.FlgEnv = YES
            FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
            FacCPedi.CodAlm = VtaTabla.Llave_c5     /* Almacén Salida */
            FacCPedi.CodCli = VtaTabla.Llave_c6     /* Almacén Destino */
        NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:        
        /*UNDO, RETURN 'ADM-ERROR'.*/
        lMensaje = "Correlativo de la Orden mal registrado o duplicado".
        UNDO LoopGrabarData, LEAVE.
    END.
    /* ************************************************************************** */
    /* Ic - 24Feb2016, la fecha de entrega de la O/D debe ser >= fecha de emision */
    /* ************************************************************************** */
    IF faccpedi.fchent < faccpedi.fchped THEN ASSIGN faccpedi.fchent = faccpedi.fchped.
    /* Controlar la hora de aprobacion para calcular la fecha del pedido*/
    DEFINE VAR lHora AS CHAR.
    DEFINE VAR lDias AS INT.
    DEFINE VAR lHoraTope AS CHAR.
    DEFINE VAR lFechaPedido AS DATE.
    lHora = STRING(TIME,"HH:MM:SS").
    lDias = 1.
    lHoraTope = '17'.   /* 5pm */
    lFechaPedido = TODAY.
    /* Si es SABADO o la hora es despues de la CINCO (17pm)*/
    IF WEEKDAY(TODAY) = 7  OR SUBSTRING(lHora,1,2) >= lHoraTope THEN DO:
        lDias = 2.
        /* Si es VIERNES despues de la 5pm */
        IF WEEKDAY(TODAY) = 6 THEN lDias = lDias + 1.
    END.
    lFechaPedido = lFechaPedido + lDias.
    IF Faccpedi.FchEnt < lFechaPedido THEN Faccpedi.FchEnt = lFechaPedido.
    /* ************************************************************************** */
    /* ************************************************************************** */
    /* *************************************** */
    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                              Faccpedi.CodDiv,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef,
                              s-User-Id,
                              'GOT',
                              'P',
                              DATETIME(TODAY, MTIME),
                              DATETIME(TODAY, MTIME),
                              Faccpedi.CodDoc,
                              Faccpedi.NroPed,
                              Faccpedi.CodRef,
                              Faccpedi.NroRef)
        NO-ERROR.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM").
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN 
        ASSIGN
        FacCPedi.DivDes = Almacen.CodDiv
        FacCPedi.NomCli = Almacen.Descripcion
        FacCPedi.DirCli = Almacen.DirAlm
        FacCPedi.Glosa  = B-CPEDI.CodRef + ' ' + B-CPEDI.NroRef + 
        "  CLIENTE: " + B-CPEDI.CodCli + ' ' + B-CPEDI.NomCli.
    FIND B-Almacen WHERE B-Almacen.codcia = Faccpedi.codcia
        AND B-Almacen.codalm = Faccpedi.codcli NO-LOCK NO-ERROR.
    IF AVAILABLE B-Almacen THEN
        ASSIGN
        FacCPedi.NomCli = B-Almacen.Descripcion
        FacCPedi.DirCli = B-Almacen.DirAlm.

    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK.
    ASSIGN
        s-FlgPicking = GN-DIVI.FlgPicking
        s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pre-Pickear */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */

    RUN Genera-Pedido.    /* Detalle del pedido */ 
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        lMensaje = "No se pudo generar el detalle de la Orden de Transferencia".
        /*UNDO, RETURN 'ADM-ERROR'.*/
        UNDO LoopGrabarData, LEAVE.
    END.

    RUN Genera-SubPedidos.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        lMensaje = "No se pudo generar el detalle de la Sub-Orden de Transferencia".
        UNDO LoopGrabarData, LEAVE.
        /*UNDO, RETURN 'ADM-ERROR'.*/
    END.

    RUN Actualiza-Pedido (+1).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        /*
        IF TRUE <> (pMensaje > '') THEN pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO, RETURN 'ADM-ERROR'.
        */
        lMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO LoopGrabarData, LEAVE.
    END.

    /* RHC 08/04/2016 Ahora sí actualizamos el estado */
    ASSIGN
        FacCPedi.FlgEst = 'P'.  /* APROBADO */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    
    x-Comprobante = Faccpedi.coddoc + ' ' + Faccpedi.nroped.
    /*
    IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
    IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
    IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
    IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
    IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
    IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
    */
END.
IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Ccbadocu) THEN RELEASE Ccbadocu.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-DPEDI)  THEN RELEASE B-DPEDI.
pMensaje = lMensaje.
IF lMensaje = "" THEN DO:
    pMensaje = 'PROCESO EXITOSO' + CHR(10) + 'Se generó el siguiente documento: ' + x-Comprobante.
    RETURN 'OK'.
END.
ELSE DO:
    RETURN "ADM-ERROR".
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
       ON STOP UNDO, RETURN 'ADM-ERROR':
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
           FacDPedi.FlgEst  = FacCPedi.FlgEst
           FacDPedi.NroItm  = I-NITEM
           FacDPedi.CanAte  = 0                     /* <<< OJO <<< */
           FacDPedi.CanSol  = FacDPedi.CanPed       /* <<< OJO <<< */
           FacDPedi.CanPick = FacDPedi.CanPed      /* <<< OJO <<< */
           NO-ERROR.
       IF ERROR-STATUS:ERROR THEN DO:
           pMensaje = "Error al grabar el producto " + B-DPEDI.codmat.
           UNDO, RETURN 'ADM-ERROR'.
       END.
       ASSIGN
           FacDPedi.Libre_d01 = B-DPEDI.CanPed
           FacDPedi.Libre_d02 = B-DPEDI.CanPed
           FacDPedi.Libre_c01 = '*'.
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
        lSector = IF (lSector = 'G-') THEN 'G0' ELSE lSector.
        /* Ic - 29Nov2016, FIN  */                                                   

        CREATE vtacdocu.
        BUFFER-COPY faccpedi TO vtacdocu
            ASSIGN 
            VtaCDocu.CodCia = faccpedi.codcia
            VtaCDocu.CodDiv = faccpedi.coddiv
            VtaCDocu.CodPed = faccpedi.coddoc
            VtaCDocu.NroPed = faccpedi.nroped + '-' + lSector /*SUBSTRING(Almmmate.CodUbi,1,2)*/
            VtaCDocu.FlgEst = 'P'   /* APROBADO */
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

