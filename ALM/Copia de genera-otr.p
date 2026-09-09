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
DEF INPUT PARAMETER pCrossDocking AS LOG.
DEF INPUT PARAMETER pAlmacenXD AS CHAR.
DEF OUTPUT PARAMETER pFechaEntrega AS DATE.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje2 AS CHAR NO-UNDO.

pMensaje = ''.
pMensaje2 = ''.

DEFINE TEMP-TABLE PEDI LIKE facdpedi.
DEFINE BUFFER B-CPEDI FOR Faccpedi.
DEFINE BUFFER B-CREPO FOR Almcrepo.
DEFINE BUFFER B-DREPO FOR Almdrepo.
DEFINE BUFFER B-ALM   FOR Almacen.

FIND B-CREPO WHERE ROWID(B-CREPO) = pRowid NO-LOCK NO-ERROR.
IF NOT AVAILABLE B-CREPO THEN DO:
    pMensaje = "NO se pudo ubicar el pedido de reposición".
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
         HEIGHT             = 5.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF SHARED VAR s-codcia AS INT.
DEF SHARED VAR s-user-id AS CHAR.

DEF VAR lDivDespacho LIKE Almacen.CodDiv NO-UNDO.
DEF VAR lAlmDespacho LIKE B-CREPO.almped NO-UNDO.

DEF VAR s-coddoc     AS CHAR INITIAL "OTR" NO-UNDO.    /* Orden de Transferencia */
DEF VAR s-codref     AS CHAR INITIAL "R/A".    /* Reposiciones Automáticas */
DEF VAR s-NroSer     AS INTEGER NO-UNDO.
DEF VAR s-TpoPed     AS CHAR NO-UNDO.

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

/* El Almacén Destino */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-CREPO.CodAlm NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    pMensaje = 'Almacén ' + B-CREPO.CodAlm + ' NO existe'.
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
/* El almacén de Despacho */
FIND FIRST Almacen WHERE Almacen.codcia = s-codcia
      AND Almacen.codalm = B-CREPO.almped NO-LOCK NO-ERROR.
IF NOT AVAILABLE almacen THEN DO:
    pMensaje = 'Almacen de despacho ' + B-CREPO.almped + ' No existe'.
    RETURN "ADM-ERROR".
END.
lDivDespacho = Almacen.CodDiv.
lAlmDespacho = B-CREPO.almped.
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
/* La serie segun el almacen de donde se desea despachar(B-CREPO.almped) segun la R/A */
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
    /* **************************************************************************** */
    /* Se toma el mayor valor de HOY y la fecha de entrega proyectada B-CREPO.Fecha */
    /* **************************************************************************** */
    lFechaPedido = MAXIMUM(TODAY, B-CREPO.Fecha).
    IF lFechaPedido = ? THEN lFechaPedido = TODAY.
    /* **************************************************************************** */
    /* **************************************************************************** */
    FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = B-CREPO.codalm NO-LOCK NO-ERROR.
    CREATE Faccpedi.
    ASSIGN 
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = s-codref      /* R/A */
        Faccpedi.FchPed = TODAY
        Faccpedi.CodDiv = lDivDespacho
        Faccpedi.FlgEst = "X"       /* EN PROCESO */
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEnv = YES
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM')
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.CodCli = B-CREPO.CodAlm
        Faccpedi.NomCli = Almacen.Descripcion
        Faccpedi.Dircli = Almacen.DirAlm
        FacCPedi.NroRef = STRING(B-CREPO.nroser,"999") + STRING(B-CREPO.nrodoc,"999999")
        FacCPedi.CodAlm = lAlmDespacho
        FacCPedi.Glosa = B-CREPO.Glosa
        NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        pMensaje = 'Error en el correlativo' + CHR(10) + 'No se pudo grabar la ' + s-coddoc.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* RHC 20/12/17 Cross Docking */
    IF pCrossDocking = YES THEN DO:
        Faccpedi.CrossDocking = YES.
        Faccpedi.AlmacenXD    = Faccpedi.CodCli.    /* Destino Final */
        Faccpedi.CodCli       = pAlmacenXD.         /* Almacén de Tránsito */
        FIND Almacen WHERE Almacen.codcia = s-codcia AND Almacen.codalm = pAlmacenXD NO-LOCK NO-ERROR.
        Faccpedi.NomCli = Almacen.Descripcion.
        Faccpedi.Dircli = Almacen.DirAlm.
    END.
    /* ************************** */
    /* Motivo */
    ASSIGN FacCPedi.MotReposicion = B-CREPO.MotReposicion.
    ASSIGN FacCPedi.VtaPuntual = B-CREPO.VtaPuntual.
    ASSIGN FacCorre.Correlativo = FacCorre.Correlativo + 1.
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
/*     lFechaPedido = MAXIMUM(TODAY, lFechaPedido).    /* CHALACASO */ */
    RUN gn/p-fchent-v3 (FacCPedi.CodAlm,
                        TODAY,
                        STRING(TIME,'HH:MM:SS'),
                        FacCPedi.CodCli,
                        FacCPedi.CodDiv,
                        cUbigeo,
                        FacCPedi.CodDoc,
                        FacCPedi.NroPed,
                        iNroSKU,
                        iPeso,
                        INPUT-OUTPUT lFechaPedido,
                        OUTPUT pMensaje).
    IF pMensaje > '' THEN DO:
        /*MESSAGE pMensaje VIEW-AS ALERT-BOX ERROR.*/
        UNDO, RETURN 'ADM-ERROR'.
    END.
    IF lFechaPedido <> B-CREPO.Fecha THEN pMensaje2 = "Se cambió la fecha de entrega a " + STRING(lFechaPedido).
    ASSIGN
        FacCPedi.FchEnt = lFechaPedido
        Faccpedi.FchVen = lFechaPedido + 7
        Faccpedi.FlgEst = "P".                  /* OJO >>> APROBADO */
    pFechaEntrega = lFechaPedido.               /* OJO: FECHA REPROGRAMADA */
    /* *********************************************************** */
    /* *********************************************************** */
    /* Actualizamos la cotizacion */
    
    RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        IF TRUE <> (pMensaje > '') THEN pMensaje = 'NO se pudo extornar la R/A'.
        UNDO, RETURN 'ADM-ERROR'.
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

    /* RHC 07/06/2018 CONSITENCIA FINAL */
/*     IF Faccpedi.CrossDocking = YES THEN DO:                                        */
/*         IF NOT CAN-FIND(FIRST Almacen WHERE Almacen.codcia = Faccpedi.codcia       */
/*                         AND Almacen.codalm = Faccpedi.CodCli                       */
/*                         AND Almacen.campo-c[1] = "XD"                              */
/*                         NO-LOCK) THEN DO:                                          */
/*             pMensaje = 'ERROR en el almacén de Cross Docking: ' + Faccpedi.CodCli. */
/*             UNDO, RETURN 'ADM-ERROR'.                                              */
/*         END.                                                                       */
/*     END.                                                                           */

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
        RUN alm/pactualizareposicion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo extornar la R/A'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* *********************************************************** */
        RUN Genera-SubOrden.
        IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
            pMensaje = 'NO se pudo generar la sub-orden'.
            UNDO PRINCIPAL, RETURN 'ADM-ERROR'.
        END.
        /* RHC 07/06/2018 CONSITENCIA FINAL */
/*         IF Faccpedi.CrossDocking = YES THEN DO:                                        */
/*             IF NOT CAN-FIND(FIRST Almacen WHERE Almacen.codcia = Faccpedi.codcia       */
/*                             AND Almacen.codalm = Faccpedi.CodCli                       */
/*                             AND Almacen.campo-c[1] = "XD"                              */
/*                             NO-LOCK) THEN DO:                                          */
/*                 pMensaje = 'ERROR en el almacén de Cross Docking: ' + Faccpedi.CodCli. */
/*                 UNDO PRINCIPAL, RETURN 'ADM-ERROR'.                                    */
/*             END.                                                                       */
/*         END.                                                                           */
    END.
END.
IF AVAILABLE(FacCorre) THEN RELEASE FacCorre.
IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
IF AVAILABLE(Faccpedi) THEN RELEASE Faccpedi.
IF AVAILABLE(B-CPEDI)  THEN RELEASE B-CPEDI.
IF AVAILABLE(B-CREPO)  THEN RELEASE B-CREPO.
IF pMensaje > '' THEN DO:
    pMensaje2 = ''.
    RETURN 'ADM-ERROR'.
END.
ELSE RETURN 'OK'.
/* -------------------------------------      */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  /* ************************************************* */
  /* RHC 23/08/17 Simplificación del proceso Max Ramos */
  /* ************************************************* */
  DEF VAR t-AlmDes AS CHAR NO-UNDO.
  DEF VAR t-CanPed AS DEC NO-UNDO.
  FOR EACH B-DREPO OF B-CREPO NO-LOCK WHERE (B-DREPO.CanApro - B-DREPO.CanAten) > 0,
      FIRST Almmmatg OF B-DREPO NO-LOCK:
      f-Factor = 1.
      t-AlmDes = ''.
      t-CanPed = 0.
      F-CANPED = (B-DREPO.CanApro - B-DREPO.CanAten).     /* OJO */
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
      BUFFER-COPY B-DREPO 
          EXCEPT B-DREPO.CanReq B-DREPO.CanApro
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
          PEDI.Libre_d01 = (B-DREPO.CanApro - B-DREPO.CanAten)
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
      /* RHC No hay límite de items 
      IF I-NPEDI > 52 THEN LEAVE.
      */
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.AlmDes = Faccpedi.CodAlm
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.FlgEst = Faccpedi.FlgEst
              FacDPedi.CanPick = FacDPedi.CanPed
              Facdpedi.NroItm = I-NPEDI.
      DELETE PEDI.
  END.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.
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

