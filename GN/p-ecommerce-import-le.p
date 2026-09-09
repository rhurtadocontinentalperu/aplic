&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
          ecommerce        PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE BUFFER b-FacCorre FOR FacCorre.
DEFINE BUFFER COTIZACION FOR FacCPedi.
DEFINE TEMP-TABLE ITEM NO-UNDO LIKE FacDPedi.
DEFINE TEMP-TABLE t-OpenCPedidos NO-UNDO LIKE OpenCPedidos.



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

DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF SHARED VAR s-CodCia AS INT.
DEF SHARED VAR s-CodDiv AS CHAR.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */

DEF VAR s-CodDoc AS CHAR NO-UNDO.
DEF VAR s-NroSer AS INTE NO-UNDO.
DEF VAR s-codmon AS INT NO-UNDO.
DEF VAR s-CodCli AS CHAR NO-UNDO.
DEF VAR s-fmapgo AS CHAR NO-UNDO.
DEF VAR s-tpocmb AS DEC NO-UNDO.
DEF VAR s-nrodec AS INT NO-UNDO.
DEF VAR s-PorIgv AS DEC NO-UNDO.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

s-CodDoc = "COT".
FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
    AND b-FacCorre.CodDoc = s-CodDoc
    AND b-FacCorre.CodDiv = s-CodDiv
    AND b-FacCorre.FlgEst = YES
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-facCorre THEN DO:
    pMensaje = 'Cod.Doc(' + s-coddoc + ") y Nro Serie(" + STRING(s-nroser,"999") + ") " +
            "No estan configurados".
    RETURN 'ADM-ERROR'.
END.
s-NroSer = b-FacCorre.NroSer.

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
      TABLE: b-FacCorre B "?" ? INTEGRAL FacCorre
      TABLE: COTIZACION B "?" ? INTEGRAL FacCPedi
      TABLE: ITEM T "?" NO-UNDO INTEGRAL FacDPedi
      TABLE: t-OpenCPedidos T "?" NO-UNDO ecommerce OpenCPedidos
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.62
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VAR x-codmat AS CHAR NO-UNDO.
DEFINE VAR x-nroitm AS INTE NO-UNDO.

DEFINE VAR x-pedidos AS INT INIT 0 NO-UNDO.
DEFINE VAR x-rowid AS ROWID NO-UNDO.

DEF VAR x-CanPed AS DECI NO-UNDO.
DEF VAR x-ImpLin AS DECI NO-UNDO.
DEF VAR x-ImpIgv AS DECI NO-UNDO.
DEF VAR x-precio AS DECI NO-UNDO.
DEF VAR x-precio-sin-igv AS DECI NO-UNDO.

DEF VAR pRowidCOT AS ROWID NO-UNDO.
DEF VAR pRowidPED AS ROWID NO-UNDO.
DEF VAR pComprobante AS CHAR NO-UNDO.
DEF VAR pSede AS CHAR NO-UNDO.

DEF VAR x-CuentaItems AS INT NO-UNDO.

/* Pedidos de ListaExpress Pendientes */
FOR EACH ecommerce.OpenCPedidos NO-LOCK WHERE ecommerce.OpenCPedidos.codcia = s-codcia AND
    ecommerce.OpenCPedidos.coddiv = s-coddiv AND
    ecommerce.OpenCPedidos.flagmigracion = '0' 
    BY ecommerce.OpenCPedidos.nroped :  
    x-pedidos = x-pedidos + 1.
    /* Guardamos CABECERA */
    CREATE t-OpenCPedidos.
    BUFFER-COPY ecommerce.OpenCPedidos TO t-OpenCPedidos.
END.
IF x-pedidos = 0 THEN DO:
    pMensaje = "No existen pedidos de ListaExpress".
    RETURN 'ADM-ERROR'.
END.

PRINCIPAL:
/* Por cada Pedido del Cliente se va a genera una COT, un PED, una O/D y una HPK */
FOR EACH t-OpenCPedidos NO-LOCK BY t-OpenCPedidos.nroped 
    TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="ecommerce.OpenCPedidos" ~
        &Alcance="FIRST" ~
        &Condicion="ecommerce.OpenCPedidos.CodCia = t-OpenCPedidos.CodCia AND ~
        ecommerce.OpenCPedidos.CodDiv = t-OpenCPedidos.CodDiv AND ~
        ecommerce.OpenCPedidos.CodDoc = t-OpenCPedidos.CodDoc AND ~
        ecommerce.OpenCPedidos.NroPed = t-OpenCPedidos.NroPed" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    /* ***************************************************************************** */
    /* Deben estar todos los items */
    /* ***************************************************************************** */
    x-CuentaItems = 0.
    FOR EACH ecommerce.OpenDPedido OF ecommerce.OpenCPedidos NO-LOCK:
        x-CuentaItems = x-CuentaItems + 1.
    END.
    IF ecommerce.OpenCPedidos.items <> x-CuentaItems THEN NEXT.
    
    /* Actualizamos Control de Migración */
    ASSIGN 
        ecommerce.OpenCPedidos.flagmigracion = '1'
        ecommerce.OpenCPedidos.MigFecha = TODAY
        ecommerce.OpenCPedidos.MigHora = STRING(TIME,"HH:MM:SS")
        ecommerce.OpenCPedidos.MigUsuario = s-user-id.
    
    /* ******************************* */
    /* Creamos el cliente si no existe */
    /* ******************************* */
    RUN Registra-Cliente (OUTPUT pSede,
                          OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "NO se pudo crear el cliente".
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        s-PorIgv = FacCfgGn.PorIgv
        s-CodMon = 1
        s-CodCli = ''
        s-FmaPgo = '000'
        s-TpoCmb = 1
        s-NroDec = 4.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
              AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    /* RHC 11.08.2014 TC Caja Compra */
    FOR EACH gn-tccja NO-LOCK BY Fecha:
        IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
    END.
    /* ***************************************************************************** */
    /* CARGAMOS DETALLE */
    /* ***************************************************************************** */
    RUN Carga-Detalle.
    /* ***************************************************************************** */
    /* COTIZACION */
    /* ***************************************************************************** */
    RUN Graba-Cotizacion (INPUT "COT", OUTPUT pRowidCOT, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ***************************************************************************** */
    /* SOLO SI LOS DOS SWITCH (ALM e INV ESTAN ACTIVOS Y VIGENTES SE CONTINÚA */
    /* ***************************************************************************** */
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
        FacTabla.Tabla = "LF" AND
        FacTabla.Codigo = "ALM" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN NEXT.
    IF FacTabla.Campo-L[1] = NO THEN NEXT.
    IF FacTabla.Campo-D[1] <> ? AND FacTabla.Campo-D[1] < TODAY THEN NEXT.
    FIND FacTabla WHERE FacTabla.CodCia = s-CodCia AND
        FacTabla.Tabla = "LF" AND
        FacTabla.Codigo = "INV" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE FacTabla THEN NEXT.
    IF FacTabla.Campo-L[1] = NO THEN NEXT.
    IF FacTabla.Campo-D[1] <> ? AND FacTabla.Campo-D[1] < TODAY THEN NEXT.
    /* ***************************************************************************** */
    /* PEDIDO LOGISTICO */
    /* ***************************************************************************** */
    RUN Graba-Pedido (INPUT pRowidCOT, INPUT "PED", OUTPUT pRowidPED, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ***************************************************************************** */
    /* ORDEN DE DESPACHO */
    /* ***************************************************************************** */
    pComprobante = "".
    RUN Graba-OD (INPUT pRowidPED, OUTPUT pComprobante, OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
END.
RETURN 'OK'.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Carga-Detalle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Carga-Detalle Procedure 
PROCEDURE Carga-Detalle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Marcamos cada uno como leido
------------------------------------------------------------------------------*/

EMPTY TEMP-TABLE ITEM.

x-NroItm = 0.
FOR EACH ecommerce.OpenDPedidos WHERE ecommerce.OpenDPedidos.CodCia = OpenCPedidos.codcia AND
    ecommerce.OpenDPedidos.CodDiv = OpenCPedidos.coddiv AND
    ecommerce.OpenDPedidos.CodDoc = OpenCPedidos.coddoc AND
    ecommerce.OpenDPedidos.NroPed = OpenCPedidos.nroped NO-LOCK:
    /* Buscar el codigo como interno */
    x-CodMat = ''.
    FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
        almmmatg.Codmat = ecommerce.OpenDPedidos.codmat NO-LOCK NO-ERROR.
    x-CodMat = IF (AVAILABLE almmmatg) THEN almmmatg.codmat ELSE ecommerce.OpenDPedidos.codmat.
    x-NroItm = x-NroItm + 1.
    CREATE ITEM.
    ASSIGN 
        ITEM.CodCia = s-codcia
        ITEM.codmat = x-CodMat
        ITEM.libre_c05 = ecommerce.OpenDPedidos.DescWeb
        ITEM.Factor = ecommerce.OpenDPedidos.factor 
        ITEM.CanPed = ecommerce.OpenDPedidos.Canped
        ITEM.NroItm = x-NroItm 
        ITEM.UndVta = ecommerce.OpenDPedidos.UndVta
        ITEM.ALMDES = ENTRY(1,S-CODALM)     /* El almacén por defecto */
        ITEM.AftIgv = ecommerce.OpenDPedidos.AftIgv
        ITEM.ImpIgv = ecommerce.OpenDPedidos.ImpIgv
        ITEM.ImpLin = ecommerce.OpenDPedidos.ImpLin
        ITEM.PreUni = ecommerce.OpenDPedidos.PreUni
        ITEM.ImpDto = ecommerce.OpenDPedidos.ImpDto
        ITEM.ImpDto2 = ecommerce.OpenDPedidos.ImpDto2
        ITEM.PorDto2 = ecommerce.OpenDPedidos.porDto2
        ITEM.ImpIgv = ecommerce.OpenDPedidos.ImpIgv .
    ASSIGN
        ITEM.CanPedWeb = ecommerce.OpenDPedidos.Canped
        ITEM.CodMatWeb = x-CodMat
        ITEM.DesMatWeb = ecommerce.OpenDPedidos.DescWeb
        ITEM.ImpLinWeb = ecommerce.OpenDPedidos.ImpLin
        ITEM.PreUniWeb = ecommerce.OpenDPedidos.PreUni .
END.

/* Ic - 26Dic2017 , Flete (Costo de envio) */
IF OpenCPedidos.impfle > 0 THEN DO:
    /* Buscar el codigo como interno del FLETE */
    x-CodMat = '044939'.
    /* Se ubico el Codigo Interno  */
    FIND Almmmatg WHERE almmmatg.codcia = s-codcia
        AND Almmmatg.codmat = x-codmat
        AND Almmmatg.tpoart <> 'D'
        NO-LOCK NO-ERROR.
    IF AVAILABLE Almmmatg THEN DO:
        /* Cantidad pedida */
        x-CanPed = OpenCPedidos.impfle.
        /* El precio final ?????????????*/
        x-precio =  1 * x-CanPed.
        /**/
        x-ImpLin =  x-precio .
        x-Precio = ROUND(x-ImpLin / x-CanPed, 5).
        x-Precio-Sin-Igv = x-Precio * 100 / (1 + s-PorIgv / 100).
        /* Verificar el IGV */
        IF x-precio > x-precio-sin-igv THEN DO:
            x-ImpIgv = x-ImpLin - (x-CanPed * x-precio-sin-igv).
        END.
        /* Items */
        x-NroItm = x-NroItm + 1.
        CREATE ITEM.
        ASSIGN 
            ITEM.CodCia = s-codcia
            ITEM.codmat = x-CodMat
            ITEM.libre_c05 = "FLETE"
            ITEM.Factor = 1 
            ITEM.CanPed = x-CanPed
            ITEM.NroItm = x-NroItm 
            ITEM.UndVta = (IF AVAILABLE Almmmatg THEN Almmmatg.Chr__01 ELSE '')
            ITEM.ALMDES = ENTRY(1,S-CODALM)     /* Almacén por defecto */
            ITEM.AftIgv = Almmmatg.AftIgv   /*(IF x-ImpIgv > 0 THEN YES ELSE NO)*/
            ITEM.ImpIgv = x-ImpIgv 
            ITEM.ImpLin = x-ImpLin /*+ x-ImpIgv*/
            ITEM.PreUni = x-precio . /* (ITEM.ImpLin / ITEM.CanPed) */
        IF ITEM.AftIgv THEN ITEM.ImpIgv = ITEM.ImpLin - ROUND( ITEM.ImpLin  / ( 1 + (s-PorIgv / 100) ), 4 ).
        ELSE ITEM.ImpIgv = 0.
        /* DATOS LISTA EXPRESS */
        ASSIGN
            ITEM.CanPedWeb = x-CanPed
            ITEM.CodMatWeb = x-CodMat
            ITEM.DesMatWeb = "FLETE"
            ITEM.ImpLinWeb = x-ImpLin
            ITEM.PreUniWeb = x-Precio .
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Cotizacion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Cotizacion Procedure 
PROCEDURE Graba-Cotizacion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Ya viene el correlativo correcto
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-CodDoc AS CHAR.       /* COT */
DEF OUTPUT PARAMETER pRowidCOT AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    CREATE FacCPedi.
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
        FacCPedi.FchPed = OpenCPedidos.FchPed
        FacCPedi.NroPed = OpenCPedidos.NroPed
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEst = "P"     /* APROBADO */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        pRowidCOT = ROWID(FacCPedi).   /* Guardamos el puntero de la COT */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
        FacCPedi.PorIgv = s-PorIgv
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = pCodDiv
        FacCPedi.CodMon = s-CodMon
        FacCPedi.Cmpbnte = "BOL"
        FacCPedi.Libre_d01  = s-NroDec
        FacCPedi.FlgIgv = YES
        FacCPedi.TpoCmb = s-tpocmb
        FacCPedi.FchVen = TODAY + s-DiasVtoCot
        FacCPedi.FchEnt = OpenCPedidos.fchent     /* Viene ya definido */
        Faccpedi.codven = s-CodVen
        Faccpedi.ImpDto2 = 0 
        FacCPedi.Glosa = OpenCPedidos.glosa.
    /* ******************************** */
    /* RHC 26/05/2020 Datos Adicionales */
    /* ******************************** */
    ASSIGN
        FacCPedi.ordcmp = OpenCPedidos.OrdCmp       /* OpenCPedidos.NroRef */
        FacCPedi.CustomerPurchaseOrder = OpenCPedidos.NroRef.
    /* ******************************** */
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = OpenCPedidos.codcli
        NO-LOCK NO-ERROR.
    ASSIGN
        s-codcli = gn-clie.codcli
        Faccpedi.codcli = gn-clie.codcli
        FacCPedi.LugEnt = OpenCPedidos.lugent.
    ASSIGN 
        FacCPedi.FmaPgo = s-FmaPgo
        Faccpedi.NomCli = OpenCPedidos.Nomcli
        Faccpedi.DirCli = OpenCPedidos.DirCli
        Faccpedi.RucCli = OpenCPedidos.RucCli
        Faccpedi.Atencion = OpenCPedidos.DNICli
        FacCPedi.NroCard = ""
        Faccpedi.CodVen = "021"
        Faccpedi.FaxCli = IF (AVAILABLE gn-clie) THEN SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
            SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2) ELSE ""
        Faccpedi.Cmpbnte = 'BOL'.    
    ASSIGN 
        Faccpedi.Cmpbnte = "BOL".
    IF Faccpedi.RucCli <> "" THEN Faccpedi.Cmpbnte = "FAC".
    /* ********************************************************************************************** */
    /* UBIGEO POR DEFECTO */
    /* ********************************************************************************************** */
    IF FacCPedi.CodCli = x-ClientesVarios THEN
        ASSIGN
            FacCPedi.Sede      = ''
            FacCPedi.CodPos    = OpenCPedidos.CodPos       /* Código Postal */
            FacCPedi.Ubigeo[2] = OpenCPedidos.CodDept 
            FacCPedi.Ubigeo[3] = OpenCPedidos.CodProv 
            FacCPedi.Ubigeo[4] = OpenCPedidos.CodDist.
    ELSE DO:
        /* ********************************************************************************************** */
        /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
        /* ********************************************************************************************** */
        FIND gn-clied WHERE gn-clied.codcia = cl-codcia
            AND gn-clied.codcli = Faccpedi.codcli
            AND gn-clied.sede = pSede       /* "@@@" */
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN
            ASSIGN
            FacCPedi.Sede      = Gn-ClieD.Sede
            FacCPedi.CodPos    = Gn-ClieD.CodPos
            FacCPedi.Ubigeo[1] = Gn-ClieD.Sede
            FacCPedi.Ubigeo[2] = "@CL"
            FacCPedi.Ubigeo[3] = Gn-ClieD.CodCli.
    END.
    /* ********************************************************************************************** */
    /* ********************************************************************************************** */
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

    FOR EACH ITEM,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
        BY ITEM.NroItm:
        I-NITEM = I-NITEM + 1.
        CREATE FacDPedi.
        BUFFER-COPY ITEM 
            TO FacDPedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst
                FacDPedi.NroItm = I-NITEM.
    END.
    /* Ic 10Feb2016 - Metodo de Pago Lista Express */
  DISABLE TRIGGERS FOR LOAD OF vtatabla.
  DEFINE BUFFER i-vtatabla FOR vtatabla.

  DEFINE VAR lxDescuentos AS DEC.    
  DEFINE VAR lxdsctosinigv AS DEC.

  /* Ic - 17Ene2018, ListaExpress desde IVERSA */
  IF TODAY > 01/01/2018 THEN DO:
      IF AVAILABLE ecommerce.OpenCPedido THEN DO:
          CREATE i-vtatabla.
              ASSIGN i-vtatabla.codcia = s-codcia
                      i-vtatabla.tabla = 'MTPGLSTEXPRS'
                      i-vtatabla.llave_c1 = FacCPedi.NroPed
                      i-vtatabla.llave_c2 = ecommerce.OpenCPedido.nroped /*tt-MetodPagoListaExpress.tt-pedidoweb*/
                      i-vtatabla.llave_c3 = ecommerce.OpenCPedido.nroref /*tt-MetodPagoListaExpress.tt-metodopago*/
                      i-vtatabla.llave_c5 = ""  /*tt-MetodPagoListaExpress.tt-tipopago                        */
                      i-vtatabla.llave_c4 = ""  /*tt-MetodPagoListaExpress.tt-nombreclie*/
                      i-vtatabla.valor[1] = 0   /*tt-MetodPagoListaExpress.tt-preciopagado*/
                      i-vtatabla.valor[2] = 0   /*tt-MetodPagoListaExpress.tt-preciounitario*/
                      i-vtatabla.valor[3] = 0   /*tt-MetodPagoListaExpress.tt-costoenvio                          */
                      i-vtatabla.valor[4] = 0.   /*tt-MetodPagoListaExpress.tt-descuento.  Importe*/  

              lxDescuentos = i-vtatabla.valor[4].
                      
      END.
  END.

  lxDescuentos = 0.
  lxdsctosinigv = 0.
  IF lxDescuentos > 0  THEN DO:
        lxdsctosinigv = (lxDescuentos * 100) / 118.
  END.
  ASSIGN faccpedi.impdto2 = lxDescuentos
        faccpedi.importe[3] = lxdsctosinigv.

  RELEASE i-vtatabla.

  /* ************************ */
  /* TOTAL GENERAL COTIZACION */
  /* ************************ */
  {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Cotizacion-Old) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Cotizacion-Old Procedure 
PROCEDURE Graba-Cotizacion-Old :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER s-CodDoc AS CHAR.       /* COT */
DEF OUTPUT PARAMETER pRowidCOT AS ROWID NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    IF FacCorre.FlgCic = NO THEN DO:
        IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
            pMensaje = 'Se ha llegado al límite del correlativo: ' + string(FacCorre.NroFin) + CHR(10) +
                'No se puede generar el documento ' + FacCorre.CodDoc + ' serie ' + string(FacCorre.NroSer,'999').
            UNDO, RETURN "ADM-ERROR".
        END.
    END.
    IF FacCorre.FlgCic = YES THEN DO:
        /* REGRESAMOS AL NUMERO 1 */
        IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
            IF FacCorre.NroIni > 0 THEN FacCorre.Correlativo = FacCorre.NroIni.
            ELSE FacCorre.Correlativo = 1.
        END.
    END.
    REPEAT:
        IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia
                        AND FacCPedi.coddiv = FacCorre.coddiv
                        AND FacCPedi.coddoc = FacCorre.coddoc
                        AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + 
                        STRING(FacCorre.correlativo, '999999')
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
    END.

    CREATE FacCPedi.
    ASSIGN 
        FacCPedi.CodCia = S-CODCIA
        FacCPedi.CodDiv = S-CODDIV
        FacCPedi.CodDoc = s-coddoc 
        FacCPedi.CodAlm = s-CodAlm    /* Lista de Almacenes Válidos de Venta */
        FacCPedi.FchPed = TODAY 
        FacCPedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        FacCPedi.TpoPed = s-TpoPed
        FacCPedi.FlgEst = "P"     /* APROBADO */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        pRowidCOT = ROWID(FacCPedi).   /* Guardamos el puntero de la COT */
    ASSIGN
        FacCorre.Correlativo = FacCorre.Correlativo + 1.
    ASSIGN 
        FacCPedi.PorIgv = s-PorIgv
        FacCPedi.Hora = STRING(TIME,"HH:MM")
        FacCPedi.Usuario = S-USER-ID
        FacCPedi.Libre_c01 = pCodDiv
        FacCPedi.CodMon = s-CodMon
        FacCPedi.Cmpbnte = "BOL"
        FacCPedi.Libre_d01  = s-NroDec
        FacCPedi.FlgIgv = YES
        FacCPedi.TpoCmb = s-tpocmb
        FacCPedi.FchVen = TODAY + s-DiasVtoCot
        FacCPedi.FchEnt = OpenCPedidos.fchent     /* Viene ya definido */
        Faccpedi.codven = s-CodVen
        faccpedi.nroref = OpenCPedidos.nroped
        Faccpedi.ImpDto2 = 0 
        FacCPedi.Glosa = OpenCPedidos.glosa.
    /* ******************************** */
    /* RHC 26/05/2020 Datos Adicionales */
    /* ******************************** */
    ASSIGN
        FacCPedi.ordcmp = OpenCPedidos.OrdCmp       /* OpenCPedidos.NroRef */
        FacCPedi.CustomerPurchaseOrder = OpenCPedidos.NroRef.
    /* ******************************** */
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = OpenCPedidos.codcli
        NO-LOCK NO-ERROR.
    ASSIGN
        s-codcli = gn-clie.codcli
        Faccpedi.codcli = gn-clie.codcli
        FacCPedi.LugEnt = OpenCPedidos.lugent.
    ASSIGN 
        FacCPedi.FmaPgo = s-FmaPgo
        Faccpedi.NomCli = OpenCPedidos.Nomcli
        Faccpedi.DirCli = OpenCPedidos.DirCli
        Faccpedi.RucCli = OpenCPedidos.RucCli
        Faccpedi.Atencion = OpenCPedidos.DNICli
        FacCPedi.NroCard = ""
        Faccpedi.CodVen = "021"
        Faccpedi.FaxCli = IF (AVAILABLE gn-clie) THEN SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
            SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2) ELSE ""
        Faccpedi.Cmpbnte = 'BOL'.    
    ASSIGN 
        Faccpedi.Cmpbnte = "BOL".
    IF Faccpedi.RucCli <> "" THEN Faccpedi.Cmpbnte = "FAC".
    /* ********************************************************************************************** */
    /* UBIGEO POR DEFECTO */
    /* ********************************************************************************************** */
    IF FacCPedi.CodCli = x-ClientesVarios THEN
        ASSIGN
            FacCPedi.Sede      = ''
            FacCPedi.CodPos    = OpenCPedidos.CodPos       /* Código Postal */
            FacCPedi.Ubigeo[2] = OpenCPedidos.CodDept 
            FacCPedi.Ubigeo[3] = OpenCPedidos.CodProv 
            FacCPedi.Ubigeo[4] = OpenCPedidos.CodDist.
    ELSE DO:
        /* ********************************************************************************************** */
        /* CONTROL DE SEDE Y UBIGEO: POR CLIENTE */
        /* ********************************************************************************************** */
        FIND gn-clied WHERE gn-clied.codcia = cl-codcia
            AND gn-clied.codcli = Faccpedi.codcli
            AND gn-clied.sede = pSede       /* "@@@" */
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clied THEN
            ASSIGN
            FacCPedi.Sede      = Gn-ClieD.Sede
            FacCPedi.CodPos    = Gn-ClieD.CodPos
            FacCPedi.Ubigeo[1] = Gn-ClieD.Sede
            FacCPedi.Ubigeo[2] = "@CL"
            FacCPedi.Ubigeo[3] = Gn-ClieD.CodCli.
    END.
    /* ********************************************************************************************** */
    /* ********************************************************************************************** */
    DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.

    FOR EACH ITEM,
        FIRST Almmmatg NO-LOCK WHERE Almmmatg.codcia = s-codcia AND Almmmatg.codmat = ITEM.codmat
        BY ITEM.NroItm:
        I-NITEM = I-NITEM + 1.
        CREATE FacDPedi.
        BUFFER-COPY ITEM 
            TO FacDPedi
            ASSIGN
                FacDPedi.CodCia = FacCPedi.CodCia
                FacDPedi.CodDiv = FacCPedi.CodDiv
                FacDPedi.coddoc = FacCPedi.coddoc
                FacDPedi.NroPed = FacCPedi.NroPed
                FacDPedi.FchPed = FacCPedi.FchPed
                FacDPedi.Hora   = FacCPedi.Hora 
                FacDPedi.FlgEst = FacCPedi.FlgEst
                FacDPedi.NroItm = I-NITEM.
    END.
    /* Ic 10Feb2016 - Metodo de Pago Lista Express */
  DISABLE TRIGGERS FOR LOAD OF vtatabla.
  DEFINE BUFFER i-vtatabla FOR vtatabla.

  DEFINE VAR lxDescuentos AS DEC.    
  DEFINE VAR lxdsctosinigv AS DEC.

  /* Ic - 17Ene2018, ListaExpress desde IVERSA */
  IF TODAY > 01/01/2018 THEN DO:
      IF AVAILABLE ecommerce.OpenCPedido THEN DO:
          CREATE i-vtatabla.
              ASSIGN i-vtatabla.codcia = s-codcia
                      i-vtatabla.tabla = 'MTPGLSTEXPRS'
                      i-vtatabla.llave_c1 = FacCPedi.NroPed
                      i-vtatabla.llave_c2 = ecommerce.OpenCPedido.nroped /*tt-MetodPagoListaExpress.tt-pedidoweb*/
                      i-vtatabla.llave_c3 = ecommerce.OpenCPedido.nroref /*tt-MetodPagoListaExpress.tt-metodopago*/
                      i-vtatabla.llave_c5 = ""  /*tt-MetodPagoListaExpress.tt-tipopago                        */
                      i-vtatabla.llave_c4 = ""  /*tt-MetodPagoListaExpress.tt-nombreclie*/
                      i-vtatabla.valor[1] = 0   /*tt-MetodPagoListaExpress.tt-preciopagado*/
                      i-vtatabla.valor[2] = 0   /*tt-MetodPagoListaExpress.tt-preciounitario*/
                      i-vtatabla.valor[3] = 0   /*tt-MetodPagoListaExpress.tt-costoenvio                          */
                      i-vtatabla.valor[4] = 0.   /*tt-MetodPagoListaExpress.tt-descuento.  Importe*/  

              lxDescuentos = i-vtatabla.valor[4].
                      
      END.
  END.

  lxDescuentos = 0.
  lxdsctosinigv = 0.
  IF lxDescuentos > 0  THEN DO:
        lxdsctosinigv = (lxDescuentos * 100) / 118.
  END.
  ASSIGN faccpedi.impdto2 = lxDescuentos
        faccpedi.importe[3] = lxdsctosinigv.

  RELEASE i-vtatabla.

  /* ************************ */
  /* TOTAL GENERAL COTIZACION */
  /* ************************ */
  {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}

END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-OD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-OD Procedure 
PROCEDURE Graba-OD :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowidPED AS ROWID.
DEF OUTPUT PARAMETER pComprobante AS CHAR NO-UNDO.      /* O/D 123123456 */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEFINE VAR hProc AS HANDLE NO-UNDO.

RUN vtagn/ventas-library PERSISTENT SET hProc.

pMensaje = "".
RLOOP:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    {lib/lock-genericov3.i ~
        &Tabla="Faccpedi" ~
        &Condicion="ROWID(Faccpedi) = pRowidPED" ~
        &Bloqueo="EXCLUSIVE-LOCK" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'" }
    IF Faccpedi.flgest <> "G" THEN DO:
        pMensaje = 'El Pedido ya fue aprobado por:' + CHR(10) +
            'Usuario: ' + FacCPedi.UsrAprobacion + CHR(10) +
            'Fecha: ' + STRING(FacCPedi.FchAprobacion) + CHR(10) + CHR(10) +
            'Proceso abortado'.
        UNDO, RETURN 'ADM-ERROR'.  
    END.
    /* ****************************** */
    /* POR DEFECTO TODO ESTA APROBADO */
    /* ****************************** */
    ASSIGN 
        Faccpedi.FlgEst = "P"
        FacCPedi.FchAprobacion = TODAY
        FacCPedi.UsrAprobacion = s-user-id.

    FOR EACH FacDPedi OF FacCPedi EXCLUSIVE-LOCK:
        ASSIGN  FacDPedi.Flgest = FacCPedi.Flgest.   /* <<< OJO <<< */
    END.
    /* TRACKING */
    FIND Almacen OF Faccpedi NO-LOCK.
    RUN vtagn/pTracking-04 (s-CodCia,
                      Almacen.CodDiv,
                      Faccpedi.CodDoc,
                      Faccpedi.NroPed,
                      s-User-Id,
                      'ANP',
                      'P',
                      DATETIME(TODAY, MTIME),
                      DATETIME(TODAY, MTIME),
                      Faccpedi.coddoc,
                      Faccpedi.nroped,
                      Faccpedi.coddoc,
                      Faccpedi.nroped).
    /* CREAMOS LA ORDEN */
    pMensaje = "".
    RUN VTA_Genera-OD IN hProc ( ROWID(Faccpedi), OUTPUT pComprobante, OUTPUT pMensaje ).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO RLOOP, RETURN 'ADM-ERROR'.

END.
DELETE PROCEDURE hProc.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Graba-Pedido) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Graba-Pedido Procedure 
PROCEDURE Graba-Pedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAMETER pRowidCOT AS ROWID.
DEF INPUT PARAMETER s-CodDoc AS CHAR.       /* PED */
DEF OUTPUT PARAMETER pRowidPED AS ROWID NO-UNDO.   /* PED */
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR x-CodAlm AS CHAR NO-UNDO.     
DEF VAR pFchEnt AS DATE NO-UNDO.
DEF VAR i-Cuenta AS INT NO-UNDO.

PRINCIPAL:
DO TRANSACTION ON ERROR UNDO, RETURN 'ADM-ERROR' ON STOP UNDO, RETURN 'ADM-ERROR':
    FIND COTIZACION WHERE ROWID(COTIZACION) = pRowidCOT NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR = YES THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    {lib/lock-genericov3.i ~
        &Tabla="FacCorre" ~
        &Alcance="FIRST" ~
        &Condicion="FacCorre.CodCia = S-CODCIA ~
        AND FacCorre.CodDoc = s-CodDoc ~
        AND FacCorre.CodDiv = s-CodDiv ~
        AND FacCorre.FlgEst = YES" ~
        &Bloqueo="EXCLUSIVE-LOCK NO-ERROR" ~
        &Accion="RETRY" ~
        &Mensaje="NO" ~
        &txtMensaje="pMensaje" ~
        &TipoError="UNDO, RETURN 'ADM-ERROR'"}
    IF FacCorre.FlgCic = NO THEN DO:
        IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
            pMensaje = 'Se ha llegado al límite del correlativo: ' + string(FacCorre.NroFin) + CHR(10) +
                'No se puede generar el documento ' + FacCorre.CodDoc + ' serie ' + string(FacCorre.NroSer,'999').
            UNDO, RETURN "ADM-ERROR".
        END.
    END.
    IF FacCorre.FlgCic = YES THEN DO:
        /* REGRESAMOS AL NUMERO 1 */
        IF FacCorre.NroFin > 0 AND FacCorre.Correlativo > FacCorre.NroFin THEN DO:
            IF FacCorre.NroIni > 0 THEN FacCorre.Correlativo = FacCorre.NroIni.
            ELSE FacCorre.Correlativo = 1.
        END.
    END.
    REPEAT:
        IF NOT CAN-FIND(FIRST FacCPedi WHERE FacCPedi.codcia = s-codcia
                        AND FacCPedi.coddiv = FacCorre.coddiv
                        AND FacCPedi.coddoc = FacCorre.coddoc
                        AND FacCPedi.nroped = STRING(FacCorre.nroser, '999') + 
                        STRING(FacCorre.correlativo, '999999')
                        NO-LOCK)
            THEN LEAVE.
        ASSIGN
            FacCorre.Correlativo = FacCorre.Correlativo + 1.
    END.

    CREATE FacCPedi.
    BUFFER-COPY COTIZACION TO Faccpedi
        ASSIGN
        Faccpedi.CodDoc = s-coddoc 
        Faccpedi.NroPed = STRING(FacCorre.NroSer,"999") + STRING(FacCorre.Correlativo,"999999")
        Faccpedi.CodRef = COTIZACION.CodDoc
        Faccpedi.NroRef = COTIZACION.NroPed
        FacCPedi.Libre_f02 = FacCPedi.FchEnt
        Faccpedi.FlgEst = "G"       /* FLAG TEMPORAL POR APROBAR */
        FacCPedi.Libre_c02 = ""  /* PCO o NORMAL */
        Faccpedi.Usuario = S-USER-ID
        Faccpedi.Hora   = STRING(TIME,"HH:MM:SS")
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &MensajeError="pMensaje" &CuentaError="i-Cuenta"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        pRowidPED = ROWID(FacCPedi).   /* Guardamos el puntero de la COT */
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
    x-CodAlm = ENTRY(1, s-CodAlm).        /* El primer almacén por defecto */
    ASSIGN 
        FacCPedi.CodAlm = x-CodAlm.               /* <<<< OJO <<<< : Almacén del PEDIDO */
    /* ********************************************************************************************** */
    /* Division destino */
    /* ********************************************************************************************** */
    FIND Almacen OF Faccpedi NO-LOCK.
    IF AVAILABLE Almacen THEN FacCPedi.DivDes = Almacen.CodDiv.
    /* ********************************************************************************************** */
    FOR EACH ITEM, FIRST Almmmatg OF ITEM NO-LOCK:
        CREATE Facdpedi.
        BUFFER-COPY ITEM
            EXCEPT ITEM.TipVta    /* Campo con valor A, B, C o D */
            TO Facdpedi
            ASSIGN
            Facdpedi.CodCia = Faccpedi.CodCia
            Facdpedi.CodDiv = Faccpedi.CodDiv
            Facdpedi.coddoc = Faccpedi.coddoc
            Facdpedi.NroPed = Faccpedi.NroPed
            Facdpedi.FchPed = Faccpedi.FchPed
            Facdpedi.Hora   = Faccpedi.Hora 
            Facdpedi.FlgEst = Faccpedi.FlgEst.
    END.
    /* ********************************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ********************************************************************************************** */
    IF COTIZACION.FchPed = COTIZACION.FchEnt 
        THEN FacCPedi.Cliente_Recoge = YES.     /* CR lo puede despachar cualquier día */
    ELSE FacCPedi.Cliente_Recoge = NO.          /* Por calendario logístico */
    /* ********************************************************************************************** */
    /* Reactualizamos la Fecha de Entrega                                             */
    /* ********************************************************************************************** */
    /* LA RUTINA VA A DECIDIR SI EL CALCULO ES POR UBIGEO O POR GPS */
    RUN logis/p-fecha-de-entrega (
        FacCPedi.CodDoc,              /* Documento actual */
        FacCPedi.NroPed,
        INPUT-OUTPUT pFchEnt,
        OUTPUT pMensaje).
    IF pMensaje > '' THEN UNDO, RETURN 'ADM-ERROR'.
    ASSIGN
        FacCPedi.FchEnt = pFchEnt.
    /* ********************************************************************************************** */
    /* Actualizamos la cotizacion */
    /* ********************************************************************************************** */
    RUN vta2/pactualizacotizacion ( ROWID(Faccpedi), "C", OUTPUT pMensaje).
    IF RETURN-VALUE = 'ADM-ERROR' THEN UNDO, RETURN 'ADM-ERROR'.
    /* ********************************************************************************************** */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Registra-Cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Cliente Procedure 
PROCEDURE Registra-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF OUTPUT PARAMETER pSede AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER pMensaje AS CHAR NO-UNDO.

DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.
DEF VAR x-Cuenta AS INT NO-UNDO.

IF ecommerce.OpenCPedidos.CodCli = x-ClientesVarios THEN RETURN 'OK'.

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = ecommerce.OpenCPedidos.CodCli
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clie THEN DO:
    /* Nuevo Cliente */
     
    /* Genera automáticamente un registro Sede = "@@@" */
    CREATE gn-clie.
    ASSIGN
        gn-clie.CodCia      = cl-codcia
        gn-clie.CodCli      = ecommerce.OpenCPedidos.CodCli
        gn-clie.Libre_C01   = "N"
        gn-clie.NomCli      = ecommerce.OpenCPedidos.NomCli
        gn-clie.DirCli      = ecommerce.OpenCPedidos.DirCli 
        gn-clie.Ruc         = ecommerce.OpenCPedidos.RucCli
        gn-clie.DNI         = ecommerce.OpenCPedidos.DNICli
        gn-clie.clfCli      = "C" 
        gn-clie.CodPais     = "01" 
        gn-clie.CodVen      = ecommerce.OpenCPedidos.CodVen
        gn-clie.CndVta      = ecommerce.OpenCPedidos.FmaPgo
        gn-clie.Fching      = TODAY 
        gn-clie.usuario     = S-USER-ID 
        gn-clie.TpoCli      = "1"
        gn-clie.CodDiv      = ecommerce.OpenCPedidos.CodDiv
        gn-clie.Rucold      = "NO"
        gn-clie.Libre_L01   = NO
        gn-clie.FlgSit      = 'A'    /* Activo */
        gn-clie.FlagAut     = 'A'   /* Autorizado */
        gn-clie.CodDept     = ecommerce.OpenCPedidos.CodDept 
        gn-clie.CodProv     = ecommerce.OpenCPedidos.CodProv 
        gn-clie.CodDist     = ecommerce.OpenCPedidos.CodDist
        gn-clie.E-Mail      = ecommerce.OpenCPedidos.E-Mail
        gn-clie.Telfnos[1]  = ecommerce.OpenCPedidos.TelephoneContactReceptor
        gn-clie.SwCargaSunat = "N"
        NO-ERROR
        .
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    cEvento = "CREATE".
    /* Buscamos Información de SUNAT: Persona Jurídica */
    IF ecommerce.OpenCPedidos.CodCli BEGINS '20' THEN DO:
        /* Verificamos Información SUNAT */
        DEF VAR pBajaSunat AS LOG NO-UNDO.
        DEF VAR pName AS CHAR NO-UNDO.
        DEF VAR pAddress AS CHAR NO-UNDO.
        DEF VAR pUbigeo AS CHAR NO-UNDO.
        DEF VAR pError AS CHAR NO-UNDO.
        DEF VAR pDateInscription AS DATE NO-UNDO.
        
        RUN gn/datos-sunat-clientes (
            INPUT ecommerce.OpenCPedidos.CodCli,
            OUTPUT pBajaSunat,
            OUTPUT pName,
            OUTPUT pAddress,
            OUTPUT pUbigeo,
            OUTPUT pDateInscription,
            OUTPUT pError )
            NO-ERROR.
        IF ERROR-STATUS:ERROR = NO AND TRUE <> (pError > '') THEN DO:
            ASSIGN
                gn-clie.DirCli  = pAddress
                gn-clie.NomCli  = pName
                gn-clie.Nombre  = pName
                gn-clie.CodDept = SUBSTRING(pUbigeo,1,2)
                gn-clie.CodProv = SUBSTRING(pUbigeo,3,2)
                gn-clie.CodDist = SUBSTRING(pUbigeo,5,2)
                gn-clie.Libre_F01 = pDateInscription
                gn-clie.SwCargaSunat = "S".
        END.
        
    END.
END.
ELSE DO:
    
    FIND CURRENT gn-clie EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
    ASSIGN
        gn-clie.NomCli      = ecommerce.OpenCPedidos.NomCli
        gn-clie.DirCli      = ecommerce.OpenCPedidos.DirCli 
        gn-clie.Ruc         = ecommerce.OpenCPedidos.RucCli
        gn-clie.DNI         = ecommerce.OpenCPedidos.DNICli
        gn-clie.FchAct = TODAY
        gn-clie.UsrAut = s-user-id
        gn-clie.CodDept     = ecommerce.OpenCPedidos.CodDept 
        gn-clie.CodProv     = ecommerce.OpenCPedidos.CodProv 
        gn-clie.CodDist     = ecommerce.OpenCPedidos.CodDist.
    cEvento = "UPDATE".
END.
IF gn-clie.codcli BEGINS '20' THEN gn-clie.Libre_C01   = "J".
IF gn-clie.codcli BEGINS '15' OR gn-clie.codcli BEGINS '17' THEN gn-clie.Libre_C01   = "E".

RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                  STRING(gn-clie.codcli, 'x(11)'), cEvento).

RELEASE gn-clie.    
/* RHC Control de Sede del Cliente */

FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = ecommerce.OpenCPedidos.CodCli
    NO-LOCK NO-ERROR.
FIND FIRST gn-clied OF gn-clie WHERE gn-clied.sedeclie = ecommerce.OpenCPedidos.IDCustomer
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE gn-clied THEN DO:
    DEFINE VAR x-correlativo AS INT INIT 0.

    DEF BUFFER x-gn-clied FOR gn-clied.

    FOR EACH x-gn-clieD OF gn-clie NO-LOCK:
        IF x-gn-clieD.sede <> '@@@' THEN DO:
            ASSIGN 
                x-correlativo = MAXIMUM(INTEGER(TRIM(x-gn-clieD.sede)),x-correlativo)
                NO-ERROR.
        END.
    END.
    
    CREATE gn-clied.
    ASSIGN
        Gn-ClieD.CodCia = gn-clie.codcia
        Gn-ClieD.CodCli = gn-clie.codcli
        Gn-ClieD.FchCreacion = TODAY
        Gn-ClieD.Sede = STRING(x-correlativo + 1,"9999")
        Gn-ClieD.SedeClie = ecommerce.OpenCPedidos.IDCustomer
        Gn-ClieD.UsrCreacion = s-user-id
        Gn-ClieD.DomFiscal = NO
        Gn-ClieD.SwSedeSunat = "M"   /* MANUAL */
        NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
ELSE DO:
    FIND CURRENT gn-clied EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF ERROR-STATUS:ERROR THEN DO:
        {lib/mensaje-de-error.i &CuentaError="x-Cuenta" &MensajeError="pMensaje"}
        UNDO, RETURN 'ADM-ERROR'.
    END.
END.
ASSIGN
    Gn-ClieD.CodDept = ecommerce.OpenCPedidos.CodDept
    Gn-ClieD.CodDist = ecommerce.OpenCPedidos.CodDist
    Gn-ClieD.CodProv = ecommerce.OpenCPedidos.CodProv
    Gn-ClieD.DirCli = ecommerce.OpenCPedidos.DirCli
    Gn-ClieD.Referencias = OpenCPedidos.ReferenceAddress
    Gn-ClieD.Libre_c04 = OpenCPedidos.TelephoneContactReceptor 
    Gn-ClieD.Libre_c05 = OpenCPedidos.ContactReceptorName.
FIND TabDistr WHERE TabDistr.CodDepto = Gn-ClieD.CodDept AND
    TabDistr.CodProvi = Gn-ClieD.CodProv AND
    TabDistr.CodDistr = Gn-ClieD.CodDist
    NO-LOCK NO-ERROR.
IF AVAILABLE TabDistr THEN DO:
    ASSIGN
        Gn-ClieD.Codpos = TabDistr.CodPos NO-ERROR.
END.
ASSIGN
    pSede = Gn-ClieD.Sede.      /* OJO */
RELEASE gn-clied.

RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

