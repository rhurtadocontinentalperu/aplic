&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE PEDI LIKE FacDPedi.



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

/* Articulo impuesto a la bolsas plasticas */
DEFINE VAR x-articulo-ICBPER AS CHAR.

x-articulo-ICBPER = "099268".

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
      TABLE: PEDI T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
DEF SHARED VAR s-CodCia AS INTE.
DEF SHARED VAR s-User-Id AS CHAR.
DEF SHARED VAR cl-codcia AS INTE.

&SCOPED-DEFINE Promocion vta2/promocion-generalv2.p


DEF NEW SHARED VAR s-CodDoc AS CHAR INIT 'PED'.
DEF NEW SHARED VAR s-codalm AS CHAR.
DEF NEW SHARED VAR s-fmapgo AS CHAR.
DEF NEW SHARED VAR s-codmon AS INT.
DEF NEW SHARED VAR s-tpoped AS CHAR INIT 'CR'.
DEF NEW SHARED VAR s-codcli AS CHAR.
DEF NEW SHARED VAR s-nrodec AS INT.
DEF NEW SHARED VAR s-PorIgv LIKE Ccbcdocu.PorIgv.


DEF BUFFER B-CMOV FOR Almcmov.
DEF BUFFER B-DMOV FOR Almdmov.
DEF BUFFER COTIZACION FOR Faccpedi.

DEF VAR pCuenta AS INTE NO-UNDO.
DEF VAR s-CodDiv AS CHAR NO-UNDO.
DEF VAR s-CodRef AS CHAR INIT 'COT' NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-NroCot AS CHAR NO-UNDO.
DEF VAR s-FlgEnv AS LOG INIT YES NO-UNDO.
DEF VAR s-Tipo-Abastecimiento AS CHAR INIT 'NORMAL' NO-UNDO.

FIND B-CMOV WHERE ROWID(B-CMOV) = pRowid NO-LOCK NO-ERROR.
IF TRUE <> (B-CMOV.NroRf3 > '') THEN RETURN 'OK'.

s-CodAlm = B-CMOV.CodAlm.       /* Del almacén del ingreso por transferencia */
s-NroCot = B-CMOV.NroRf3.

/* Buscamos la Cotizacion */
FIND COTIZACION WHERE COTIZACION.codcia = s-CodCia
    AND COTIZACION.coddoc = 'COT'
    AND COTIZACION.nroped = B-CMOV.NroRf3
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE COTIZACION THEN RETURN 'OK'.
s-CodDiv = COTIZACION.CodDiv.
s-PorIgv = COTIZACION.PorIgv.
/* Nro de Serie */
FIND FIRST FacCorre WHERE FacCorre.CodCia = S-CODCIA AND
    FacCorre.CodDoc = S-CODDOC AND
    FacCorre.CodDiv = S-CODDIV AND
    FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE FacCorre THEN DO:
    pMensaje = "Codigo de Documento " + s-CodDoc + " NO configurado".
    RETURN 'ADM-ERROR'.
END.
s-NroSer = FacCorre.NroSer.

DEF VAR I-NPEDI AS INTE NO-UNDO.
DEF VAR t-CanPed AS DECI NO-UNDO.

/* */
DEFINE VARIABLE s-FlgEmpaque LIKE gn-divi.FlgEmpaque.
DEFINE VARIABLE s-DiasVtoPed LIKE GN-DIVI.DiasVtoPed.
DEFINE VARIABLE s-VentaMayorista LIKE GN-DIVI.VentaMayorista.

/* **************************************************** */
/* RHC 31/01/2018 PARAMETROS DE ACUERDO A LA COTIZACION */
/* **************************************************** */
DEF BUFFER B-DIVI FOR gn-divi.
FIND B-DIVI WHERE B-DIVI.codcia = s-codcia 
    AND B-DIVI.coddiv = COTIZACION.Libre_c01 NO-LOCK NO-ERROR.
IF AVAILABLE B-DIVI THEN DO:
    ASSIGN
        s-DiasVtoPed = B-DIVI.DiasVtoPed
        s-FlgEmpaque = B-DIVI.FlgEmpaque
        s-VentaMayorista = B-DIVI.VentaMayorista.
END.

RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    /* ********************************************************************************************** */
    /* Bloqueamos Correlativo */
    /* ********************************************************************************************** */
    {lib/lock-genericov3.i
        &Tabla="FacCorre"
        &Alcance="FIRST"
        &Condicion="Faccorre.codcia = s-codcia ~
            AND Faccorre.coddoc = s-coddoc ~
            AND Faccorre.nroser = s-nroser"
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR"
        &Accion="RETRY"
        &Mensaje="NO"
        &txtMensaje="pMensaje"
        &TipoError="UNDO, RETURN 'ADM-ERROR'"
        }
    /* ********************************************************************************************** */
    /* Cargamos detalle */
    /* ********************************************************************************************** */
    EMPTY TEMP-TABLE PEDI.
    FOR EACH B-DMOV OF B-CMOV NO-LOCK, FIRST Almmmatg OF B-DMOV NO-LOCK,
        FIRST Facdpedi OF COTIZACION NO-LOCK WHERE Facdpedi.codmat = B-DMOV.codmat
        AND (Facdpedi.CanPed - Facdpedi.CanAte) > 0:
        t-CanPed = MINIMUM( (Facdpedi.CanPed - Facdpedi.CanAte) * Facdpedi.Factor,
                            (B-DMOV.CanDes * B-DMOV.Factor) ).
        t-CanPed = t-CanPed / Facdpedi.Factor.  /* En las unidades de la COTIZACION */
        I-NPEDI = I-NPEDI + 1.
        CREATE PEDI.
        BUFFER-COPY FacDPedi 
            EXCEPT Facdpedi.CanSol Facdpedi.CanApr
            TO PEDI
            ASSIGN 
            PEDI.CodCia = s-codcia
            PEDI.CodDiv = s-coddiv
            PEDI.CodDoc = "PED"
            PEDI.NroPed = ''
            PEDI.CodCli = COTIZACION.CodCli
            PEDI.ALMDES = s-CodAlm  /* *** OJO *** */
            PEDI.NroItm = I-NPEDI
            PEDI.CanPed = t-CanPed    /* << OJO << */
            PEDI.CanAte = 0.
        ASSIGN
            PEDI.Libre_d01 = (FacDPedi.CanPed - FacDPedi.CanAte)
            PEDI.Libre_d02 = t-CanPed
            PEDI.Libre_c01 = '*'.
        /* RHC 28/04/2016 Caso extraño */
        IF PEDI.CanPed > PEDI.Libre_d01 
            THEN ASSIGN PEDI.CanPed = PEDI.Libre_d01 PEDI.Libre_d02 = PEDI.Libre_d01.
        /* *************************** */
        IF PEDI.CanPed <> facdPedi.CanPed THEN DO:
            {vta2/calcula-linea-detalle.i &Tabla="PEDI"}.
        END.
    END.
    FIND FIRST PEDI NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PEDI THEN RETURN 'OK'.     /* NO hay datos */
    /* ********************************************************************************************** */
    /* SIEMPRE Bloqueamos la COTIZACION */
    /* ********************************************************************************************** */
    FIND CURRENT COTIZACION EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="pCuenta" &MensajeError="pMensaje"}
        UNDO RLOOP, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************** */
    /* NUEVO PEDIDO */
    /* ********************************************************************************************** */
    CREATE Faccpedi.
    BUFFER-COPY COTIZACION TO Faccpedi
        ASSIGN
        Faccpedi.FchPed = TODAY
        Faccpedi.FchVen = TODAY + s-DiasVtoPed
        Faccpedi.Sede   = "@@@"
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS")
        Faccpedi.CodCia = S-CODCIA
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = s-CodRef      /* COT */
        Faccpedi.NroRef = s-NroCot
        Faccpedi.FchPed = TODAY 
        Faccpedi.PorIgv = s-PorIgv 
        Faccpedi.CodDiv = S-CODDIV
        Faccpedi.FlgEst = "G"       /* FLAG TEMPORAL POR APROBAR */
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEnv = s-FlgEnv
        FacCPedi.Libre_c01 = s-User-id + '|' + STRING(DATETIME(TODAY, MTIME), '99/99/9999 HH:MM:SS')
        /* INFORMACION PARA LISTA EXPRESS */
        FacCPedi.PorDto     = COTIZACION.PorDto      /* Descuento LISTA EXPRESS */
        FacCPedi.ImpDto2    = COTIZACION.ImpDto2     /* Importe Decto Lista Express */
        FacCPedi.Importe[2] = COTIZACION.Importe[2] /* Importe Dcto Lista Express SIN IGV */
        FacCPedi.Libre_c02 = s-Tipo-Abastecimiento  /* PCO o NORMAL */
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="pCuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************** */
    /* INFORMACION QUE NO SE VE EN EL VIEWER */
    /* ********************************************************************************************** */
    ASSIGN
        FacCPedi.NroCard = COTIZACION.NroCard
        FacCPedi.CodVen  = COTIZACION.CodVen.
    /* ********************************************************************************************** */
    /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
    /* ********************************************************************************************** */
    FIND FIRST gn-clied WHERE gn-clied.codcia = cl-codcia
        AND gn-clied.codcli = Faccpedi.codcli
        AND gn-clied.sede = Faccpedi.sede
        NO-LOCK NO-ERROR.
    ASSIGN
        FacCPedi.Ubigeo[1] = FacCPedi.Sede
        FacCPedi.Ubigeo[2] = "@CL"
        FacCPedi.Ubigeo[3] = FacCPedi.CodCli.
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    /* TRACKING */
    RUN vtagn/pTracking-04 (s-CodCia,
                            s-CodDiv,
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            s-User-Id,
                            'GNP',
                            'P',
                            DATETIME(TODAY, MTIME),
                            DATETIME(TODAY, MTIME),
                            Faccpedi.CodDoc,
                            Faccpedi.NroPed,
                            Faccpedi.CodRef,
                            Faccpedi.NroRef).
    /* ********************************************************************************************** */
    /* Definimos cuantos almacenes hay de despacho */
    /* Cuando se modifica un pedido hay solo un almacén */
    /* ********************************************************************************************** */
    ASSIGN 
        FacCPedi.CodAlm = s-CodAlm.               /* <<<< OJO <<<< : Almacén del PEDIDO */
    /* ********************************************************************************************** */
    /* Division destino */
    /* ********************************************************************************************** */
    FIND Almacen OF Faccpedi NO-LOCK.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* ********************************************************************************************** */
    /* Las Promociones solo se calculan en el PRIMER PEDIDO */
    /* ********************************************************************************************** */
    /* RHC 05/05/2014 nueva rutina de promociones */
    RUN {&Promocion} (COTIZACION.Libre_c01, Faccpedi.CodCli, INPUT-OUTPUT TABLE PEDI, OUTPUT pMensaje).
    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    /* ********************************************************************************************** */
    /* CARGAMOS LA INFORMACION POR ALMACEN DESPACHO */
    /* ********************************************************************************************** */
    RUN Genera-Pedido.    /* Detalle del pedido */
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = 'NO se pudo generar el pedido' + CHR(10) + 'NO hay stock suficiente en los almacenes'.
        UNDO, RETURN 'ADM-ERROR'.
    END.
    /* ********************************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ********************************************************************************************** */
    DEF VAR pFchEnt AS DATE NO-UNDO.
    RUN Fecha-Entrega (OUTPUT pFchEnt, OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.
    /* ****************************************************************************** */
    /* Grabamos Totales */
    /* ********************************************************************************************** */
    RUN Graba-Totales.
    /* ********************************************************************************************** */
    /* Actualizamos la cotizacion */
    /* ********************************************************************************************** */
    RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ********************************************************************************************** */
END.

RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Fecha-Entrega) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Fecha-Entrega Procedure 
PROCEDURE Fecha-Entrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pFchEnt    AS DATE.
DEF OUTPUT PARAMETER pMensaje   AS CHAR.

/* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
RUN logis/p-fecha-de-entrega (
    FacCPedi.CodDoc,              /* Documento actual */
    FacCPedi.NroPed,
    INPUT-OUTPUT pFchEnt,
    OUTPUT pMensaje).
              
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
  DEFINE VARIABLE f-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE x-CanPed AS DEC NO-UNDO.
  DEFINE VARIABLE s-StkComprometido AS DEC.
  DEFINE VARIABLE s-StkDis AS DEC NO-UNDO.

  DEF VAR f-PreBas AS DEC NO-UNDO.
  DEF VAR f-PreVta AS DEC NO-UNDO.
  DEF VAR f-Dsctos AS DEC NO-UNDO.
  DEF VAR y-Dsctos AS DEC NO-UNDO.
  DEF VAR SW-LOG1  AS LOGI NO-UNDO.
  DEF VAR x-StkAct AS DEC NO-UNDO.

  DEF VAR pSugerido AS DEC NO-UNDO.
  DEF VAR pEmpaque AS DEC NO-UNDO.

  /* RHC 24/04/2020 Validación VENTA DELIVERY */
  DEF VAR x-VentaDelivery AS LOG NO-UNDO.
  FIND FIRST FacTabla WHERE FacTabla.CodCia = s-CodCia AND
      FacTabla.Tabla = "GN-DIVI" AND
      FacTabla.Codigo = s-CodDiv AND
      FacTabla.Campo-L[3] = YES   /* Solo pedidos al 100% */
      NO-LOCK NO-ERROR.
  IF AVAILABLE FacTabla THEN x-VentaDelivery = YES.
  ELSE x-VentaDelivery = NO.
       
  DETALLES:
  /* RHC 13/06/2020 NO se verifica el stock de productos con Cat. Contab. = "SV" */
  /* RHC 10/07/2020 NO se verifica el stock de productos Drop Shipping */
  FOR EACH PEDI, 
      FIRST Almmmatg OF PEDI NO-LOCK,
      FIRST Almtfami OF Almmmatg NO-LOCK 
      BY PEDI.NroItm:
      IF Almtfami.Libre_c01 = "SV" THEN NEXT.
      FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND
          VtaTabla.Tabla = "DROPSHIPPING" AND
          VtaTabla.Llave_c1 = PEDI.CodMat 
          NO-LOCK NO-ERROR.
/*       FIND FIRST VtaTabla WHERE VtaTabla.CodCia = s-CodCia AND */
/*           VtaTabla.Tabla = "DROPSHIPPING" AND                  */
/*           VtaTabla.Llave_c1 = s-CodDiv AND                     */
/*           VtaTabla.Llave_c2 = PEDI.CodMat                      */
/*           NO-LOCK NO-ERROR.                                    */
      IF AVAILABLE VtaTabla THEN NEXT.
      /* **************************************************************************************** */
      f-Factor = PEDI.Factor.
      x-CanPed = PEDI.CanPed * f-Factor.
      /* EMPAQUE SUPERMERCADOS */
      FIND FIRST supmmatg WHERE supmmatg.codcia = FacCPedi.CodCia
          AND supmmatg.codcli = FacCPedi.CodCli
          AND supmmatg.codmat = PEDI.codmat 
          NO-LOCK NO-ERROR.
      f-CanPed = PEDI.CanPed * f-Factor.
      IF AVAILABLE supmmatg AND supmmatg.Libre_d01 <> 0 THEN DO:
          f-CanPed = (TRUNCATE((f-CanPed / supmmatg.Libre_d01),0) * supmmatg.Libre_d01).
      END.
      ELSE DO:    /* EMPAQUE OTROS */
          IF s-FlgEmpaque = YES THEN DO:
              CASE TRUE:
                  WHEN s-Tipo-Abastecimiento = "PCO" THEN DO:
                      RUN vtagn/p-cantidad-sugerida-pco.p (PEDI.codmat, 
                                                           f-CanPed, 
                                                           OUTPUT pSugerido, 
                                                           OUTPUT pEmpaque).
                      f-CanPed = pSugerido.
                      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
                  END.
                  OTHERWISE DO:
                      RUN vtagn/p-cantidad-sugerida.p (s-TpoPed,
                                                       PEDI.codmat, 
                                                       f-CanPed, 
                                                       OUTPUT pSugerido, 
                                                       OUTPUT pEmpaque).
                      f-CanPed = pSugerido.
                      f-CanPed = ((f-CanPed - (f-CanPed MODULO f-Factor)) / f-Factor).  /* En unidades de venta */
                  END.
              END CASE.
          END.
      END.
      IF f-CanPed <> PEDI.CanPed THEN DO:
          /* ******************************** */
          /* Venta Delivery NO DESPACHAR NADA */
          /* ******************************** */
          IF x-VentaDelivery = YES THEN RETURN "ADM-ERROR".
          /* ******************************** */
      END.
      IF PEDI.CanPed <= 0 THEN DO:
          DELETE PEDI.
      END.
  END.
  /* RECALCULAMOS */
  FOR EACH PEDI:
      {vta2/calcula-linea-detalle.i &Tabla="PEDI"}
      IF PEDI.CanPed <= 0 THEN DELETE PEDI.
  END.
  /* AHORA SÍ GRABAMOS EL PEDIDO */
  FOR EACH PEDI, FIRST Almmmatg OF PEDI NO-LOCK BY PEDI.NroItm: 
      I-NPEDI = I-NPEDI + 1.
      CREATE Facdpedi.
      BUFFER-COPY PEDI 
          EXCEPT PEDI.TipVta    /* Campo con valor A, B, C o D */
          TO Facdpedi
          ASSIGN
              Facdpedi.CodCia = Faccpedi.CodCia
              Facdpedi.CodDiv = Faccpedi.CodDiv
              Facdpedi.coddoc = Faccpedi.coddoc
              Facdpedi.NroPed = Faccpedi.NroPed
              Facdpedi.FchPed = Faccpedi.FchPed
              Facdpedi.Hora   = Faccpedi.Hora 
              Facdpedi.NroItm = I-NPEDI.
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

&IF DEFINED(EXCLUDE-Graba-Totales) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Totales Procedure 
PROCEDURE Graba-Totales :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{vta2/graba-totales-cotizacion-cred.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

