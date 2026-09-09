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

pMensaje = ''.

DEFINE TEMP-TABLE PEDI LIKE facdpedi.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-DPEDI FOR Facdpedi.
DEFINE BUFFER B-ALM   FOR Almacen.

FIND B-CPEDI WHERE ROWID(B-CPEDI) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CPEDI THEN DO:
    pMensaje = "NO se pudo ubicar el pedido de ventas".
    RETURN 'ADM-ERROR'.
END.
IF B-CPEDI.FlgEst <> "P" THEN RETURN "OK".
/* DEBE SER PARA CROSS DOCKING */
IF B-CPEDI.CrossDocking = NO THEN DO:
    pMensaje = "Si NO es para Cross Docking NO debe generar una ORDEN DE TRANSFERENCIA".
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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR lDivDespacho AS CHAR NO-UNDO.
DEF VAR lAlmDespacho AS CHAR NO-UNDO.

DEF VAR s-coddoc     AS CHAR INITIAL "OTR" NO-UNDO.    /* Orden de Transferencia */
DEF VAR s-NroSer     AS INT  NO-UNDO.
DEF VAR s-TpoPed     AS CHAR INITIAL "" NO-UNDO.

/* PARAMETROS DE PEDIDOS PARA LA DIVISION */
DEF VAR s-FlgEmpaque LIKE GN-DIVI.FlgEmpaque.
DEF VAR s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEF VAR s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

DEFINE VARIABLE s-FlgPicking LIKE GN-DIVI.FlgPicking.
DEFINE VARIABLE s-FlgBarras LIKE GN-DIVI.FlgBarras.

DEF VAR iNroSKU     AS INT NO-UNDO.
DEF VAR iPeso       AS DEC NO-UNDO.
DEF VAR cUbigeo     AS CHAR NO-UNDO.
DEF VAR lHora       AS CHAR NO-UNDO.
DEF VAR lDias       AS INT NO-UNDO.
DEF VAR lHoraTope   AS CHAR NO-UNDO.
DEF VAR lFechaPedido AS DATE NO-UNDO.

/* El Almacén Destino (El que va a hacer el despacho final al cliente) */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-CPEDI.AlmacenXD NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    pMensaje = 'Almacén ' + B-CPEDI.AlmacenXD + ' NO existe'.
    RETURN "ADM-ERROR".
END.
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = Almacen.CodDiv
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + Almacen.CodDiv + ' NO configurada'.
    RETURN "ADM-ERROR".
END.
cUbigeo = TRIM(gn-divi.Campo-Char[3]) + TRIM(gn-divi.Campo-Char[4]) + TRIM(gn-divi.Campo-Char[5]).
/* El almacén de Despacho (El que debería despachar al cliente) */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-CPEDI.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE Almacen THEN DO:
    pMensaje = 'Almacen de despacho ' + B-CPEDI.CodAlm + ' No existe'.
    RETURN "ADM-ERROR".
END.
lDivDespacho = Almacen.CodDiv.
lAlmDespacho = Almacen.CodAlm.
/* Control del correlativo */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDiv = lDivDespacho AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
   pMensaje = "Codigo de Documento " + s-coddoc + " No configurado para la division " + lDivDespacho.
   RETURN "ADM-ERROR".
END.
/* La serie segun el almacén de donde se desea despachar */
s-NroSer = FacCorre.NroSer.
/* Datos de la División de Despacho */
FIND gn-divi WHERE gn-divi.codcia = s-codcia
    AND gn-divi.coddiv = lDivDespacho
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-divi THEN DO:
    pMensaje = 'División ' + lDivDespacho + ' NO configurada'.
    RETURN "ADM-ERROR".
END.
ASSIGN
    s-DiasVtoPed = GN-DIVI.DiasVtoPed
    s-FlgEmpaque = GN-DIVI.FlgEmpaque
    s-VentaMayorista = GN-DIVI.VentaMayorista.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND CURRENT B-CPEDI EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE B-CPEDI THEN UNDO, RETURN 'ADM-ERROR'.
    /* Paso 01 : Llenar el Temporal con el detalle de los Articulos */
    RUN cargar-temporal-otr.
    /* Paso 02 : Adiciono el Registro en la Cabecera */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Condicion="Faccorre.codcia = s-codcia
        AND Faccorre.coddoc = s-coddoc
        AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* ***************************************************************** */
    /* Determino la fecha de entrega del pedido */
    /* ***************************************************************** */
    ASSIGN
        iNroSKU = 0
        iPeso = 0.
    FOR EACH PEDI NO-LOCK, FIRST Almmmatg OF PEDI NO-LOCK:
        iNroSKU = iNroSKU + 1.
        iPeso = iPeso + (PEDI.CanPed * PEDI.Factor) * Almmmatg.PesMat.
    END.
    lFechaPedido = MAXIMUM(TODAY, B-CPEDI.FchEnt).
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = B-CPEDI.codalm NO-LOCK NO-ERROR.
    CREATE Faccpedi.
    BUFFER-COPY B-CPEDI TO Faccpedi
        ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDiv = lDivDespacho
        Faccpedi.CodDoc = s-coddoc      /* OTR */
        Faccpedi.TpoPed = s-tpoped      /* "" */
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.CodAlm = lAlmDespacho
        Faccpedi.FchPed = TODAY
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodRef = B-CPEDI.CodDoc    /* PED */
        FacCPedi.NroRef = B-CPEDI.NroPed
        FacCPedi.Glosa = B-CPEDI.Glosa
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'NO se pudo grabar la ' + s-coddoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* RHC 20/12/17 Cross Docking */
    ASSIGN
        Faccpedi.CrossDocking = YES
        Faccpedi.AlmacenXD    = Faccpedi.CodCli.            /* Destino Final (Cliente) */
    ASSIGN
        Faccpedi.CodCli       = B-CPEDI.AlmacenXD.          /* Almacén de Tránsito */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = B-CPEDI.AlmacenXD NO-LOCK NO-ERROR.
    ASSIGN
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm.
    /* ************************** */
    ASSIGN 
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* Actualizamos la hora cuando lo vuelve a modificar */
    ASSIGN
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM").
    /* Division destino */
    FIND Almacen OF Faccpedi NO-LOCK NO-ERROR.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* CONTROL DE OTROS PROCESOS POR DIVISION */
    FIND gn-divi WHERE gn-divi.codcia = Faccpedi.codcia
        AND gn-divi.coddiv = Faccpedi.divdes
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-divi THEN
        ASSIGN
            s-FlgPicking = GN-DIVI.FlgPicking
            s-FlgBarras  = GN-DIVI.FlgBarras.
    IF s-FlgPicking = YES THEN FacCPedi.FlgSit = "T".    /* Por Pre-Pickear */
    IF s-FlgPicking = NO AND s-FlgBarras = NO THEN FacCPedi.FlgSit = "C".    /* Barras OK */
    IF s-FlgPicking = NO AND s-FlgBarras = YES THEN FacCPedi.FlgSit = "P".   /* Pre-Picking OK */
    /* DETALLE DE LA OTR */
    RUN Genera-Pedido.    /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar la OTR' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************** */
    /* FECHA DE ENTREGA */
    /* *********************************************************** */
    RUN logis/p-fecha-de-entrega (Faccpedi.CodDoc,
                                  Faccpedi.NroPed,
                                  INPUT-OUTPUT lFechaPedido,
                                  OUTPUT pMensaje).
/*     RUN gn/p-fchent-v3 (FacCPedi.CodAlm,           */
/*                         TODAY,                     */
/*                         STRING(TIME,'HH:MM:SS'),   */
/*                         FacCPedi.CodCli,           */
/*                         FacCPedi.CodDiv,           */
/*                         cUbigeo,                   */
/*                         FacCPedi.CodDoc,           */
/*                         FacCPedi.NroPed,           */
/*                         iNroSKU,                   */
/*                         iPeso,                     */
/*                         INPUT-OUTPUT lFechaPedido, */
/*                         OUTPUT pMensaje).          */
    IF pMensaje > '' THEN DO:
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                  /* OJO >>> APROBADO */
    /*pFechaEntrega = lFechaPedido.               /* OJO: FECHA REPROGRAMADA */*/
    /* *********************************************************** */
    /* *********************************************************** */
    /* Actualizamos la cotizacion */
    RUN Actualiza-Pedido (+1).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
        UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
    END.
    /* *********************************************************** */
    /* TRACKING */
    RUN vtagn/pTracking-04 (Faccpedi.CodCia,
                            Faccpedi.CodDiv,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef,
                            s-User-Id,
                            'GOT',    /* Generación OTR */
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef)
        NO-ERROR.
    /* *********************************************************** */
    RUN Genera-SubOrden.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar la sub-orden'.
        UNDO, RETURN 'ADM-ERROR'.
    END.

    /* ************ CREAMOS VARIAS OTRs SI FUERA NECESARIO ************* */
    REPEAT ON ERROR UNDO PRINCIPAL, RETURN 'ADM-ERROR' ON STOP UNDO PRINCIPAL, RETURN 'ADM-ERROR':
        FIND FIRST PEDI NO-ERROR.
        IF NOT AVAILABLE PEDI THEN LEAVE.
        CREATE B-CPEDI.
        BUFFER-COPY FacCPedi TO B-CPEDI ASSIGN B-CPEDI.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999").
        ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
        FIND FacCPedi WHERE ROWID(Faccpedi) = ROWID(B-CPEDI).
        RUN Genera-Pedido.    /* Detalle del pedido */
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* Actualizamos la cotizacion */
        RUN Actualiza-Pedido (+1).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = "ERROR: No se pudo actualizar el saldo del Pedido".
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************** */
        RUN Genera-SubOrden.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar la sub-orden'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF pMensaje > '' THEN RETURN 'ADM-ERROR'.
ELSE RETURN 'OK'.
/* -------------------------------------      */

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
      FIND FIRST B-DPEDI WHERE B-DPEDI.CodCia = B-CPEDI.CodCia 
          AND B-DPEDI.CodDiv = B-CPEDI.CodDiv
          AND B-DPEDI.CodDoc = B-CPEDI.CodDoc
          AND B-DPEDI.NroPed = B-CPEDI.NroPed
          AND B-DPEDI.CodMat = FacDPedi.CodMat 
/*           AND B-DPEDI.AlmDes = FacDPedi.AlmDes                                */
/*           AND B-DPEDI.Libre_c05 = FacDPedi.Libre_c05    /* OF: Promocional */ */
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

&IF DEFINED(EXCLUDE-cargar-temporal-otr) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cargar-temporal-otr Procedure 
PROCEDURE cargar-temporal-otr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.
  DEFINE VARIABLE F-CANPED AS DECIMAL NO-UNDO.
  DEFINE VARIABLE x-StkAct AS DEC NO-UNDO.
  DEFINE VARIABLE x-CodAlm AS CHAR NO-UNDO.
  DEFINE VARIABLE i AS INT NO-UNDO.

  EMPTY TEMP-TABLE PEDI.
  i-NPedi = 0.
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  FOR EACH B-DPEDI OF B-CPEDI NO-LOCK, FIRST Almmmatg OF B-DPEDI NO-LOCK:
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      F-CANPED = (B-DPEDI.CanPed - B-DPEDI.CanAte).     /* OJO */
      x-CodAlm = lAlmDespacho.
      /* DEFINIMOS LA CANTIDAD */
      x-CanPed = f-CanPed * f-Factor.
      IF f-CanPed <= 0 THEN NEXT.
      IF f-CanPed > t-CanPed THEN DO:
          t-CanPed = f-CanPed.
          t-AlmDes = x-CodAlm.
      END.
      /* GRABACION */
      I-NPEDI = I-NPEDI + 1.
      CREATE PEDI.
      BUFFER-COPY B-DPEDI 
          TO PEDI
          ASSIGN 
              PEDI.CodCia = s-codcia
              PEDI.CodDiv = lDivDespacho
              PEDI.CodDoc = s-coddoc
              PEDI.NroPed = ''
              PEDI.ALMDES = t-AlmDes  /* *** OJO *** */
              PEDI.NroItm = I-NPEDI
              PEDI.CanPed = t-CanPed            /* << OJO << */
              PEDI.CanAte = 0.
      ASSIGN
          PEDI.Libre_d01 = (B-DPEDI.CanPed - B-DPEDI.CanAte)
          PEDI.Libre_d02 = t-CanPed
          PEDI.Libre_c01 = '*'.
      ASSIGN
          PEDI.UndVta = Almmmatg.UndBas.
  END.

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
  DEFINE VARIABLE I-NPEDI AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE f-Factor AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  /* POR CADA PEDI VOLVEMOS A VERIFICAR EL STOCK DISPONIBLE */
  /* Borramos data sobrante */
  FOR EACH PEDI WHERE PEDI.CanPed <= 0:
      DELETE PEDI.
  END.

  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      /* RHC 10/08/2018 NO va a haber límite de items 
      IF I-NPEDI > 52 THEN LEAVE.
      */
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.AlmDes = Faccpedi.CodAlm
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              FacDPedi.CanPick = FacDPedi.CanPed
              Facdpedi.NroItm = I-NPEDI.
      DELETE PEDI.
  END.
  /* verificamos que al menos exista 1 item grabado */
  FIND FIRST Facdpedi OF Faccpedi NO-LOCK NO-ERROR.
  IF NOT AVAILABLE Facdpedi 
  THEN RETURN 'ADM-ERROR'.
  ELSE RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Genera-SubOrden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Genera-SubOrden Procedure 
PROCEDURE Genera-SubOrden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* SOLO para O/D control de Pickeo */
IF FacCPedi.FlgSit <> "T" THEN RETURN 'OK'.

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

/* El SECTOR forma parte del código de ubicación */
FOR EACH facdpedi OF faccpedi NO-LOCK,
    FIRST almmmate NO-LOCK WHERE Almmmate.CodCia = facdpedi.codcia
    AND Almmmate.CodAlm = facdpedi.almdes
    AND Almmmate.codmat = facdpedi.codmat
    BREAK BY SUBSTRING(Almmmate.CodUbi,1,2)
    ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    IF FIRST-OF(SUBSTRING(Almmmate.CodUbi,1,2)) THEN DO:
        /* Ic - 29Nov2016, G- = G0 */
        lSector = CAPS(SUBSTRING(Almmmate.CodUbi,1,2)).
        lUbic = TRIM(Almmmate.CodUbi).
        lSectorOK = NO.
        /* Si el sector es Correcto y el codigo de la ubicacion esta OK */
        /* 18May2017 Felix Perez creo una nueva ZONA (07) */
        IF (lSector >= '01' AND lSector <= '07') AND LENGTH(lUbic) = 7 THEN DO:
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
                NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                pMensaje = "Error al grabar la suborden " + faccpedi.nroped + '-' + SUBSTRING(Almmmate.CodUbi,1,2).
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
        VtaDDocu.CodUbi = Almmmate.CodUbi.
END.
IF AVAILABLE vtacdocu THEN RELEASE vtacdocu.
IF AVAILABLE vtaddocu THEN RELEASE vtaddocu.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

