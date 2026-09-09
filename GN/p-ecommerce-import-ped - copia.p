&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
/* Connected Databases 
          integral         PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE SHARED TEMP-TABLE ITEM LIKE FacDPedi.
DEFINE TEMP-TABLE ITEM-LE LIKE FacDPedi.



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
DEF SHARED VAR s-CodDoc AS CHAR.
DEF SHARED VAR s-NroSer AS INT.
DEF SHARED VAR s-MinimoDiasDespacho AS DEC.
DEF SHARED VAR s-DiasVtoCot LIKE GN-DIVI.DiasVtoCot.
DEF SHARED VAR s-codven AS CHAR.
DEF SHARED VAR cl-codcia AS INT.
DEF SHARED VAR s-codalm AS CHAR.
DEF SHARED VAR s-user-id AS CHAR.
DEF SHARED VAR s-tpoped AS CHAR.
DEF SHARED VAR pCodDiv  AS CHAR.        /* DIVISION DE LA LISTA DE PRECIOS */

DEF VAR s-codmon AS INT.
DEF VAR s-CodCli AS CHAR.
DEF VAR s-fmapgo AS CHAR.
DEF VAR s-tpocmb AS DEC.
DEF VAR s-nrodec AS INT.
DEF VAR s-PorIgv AS DEC.

DEFINE BUFFER b-FacCorre FOR integral.FacCorre.                                
DEFINE BUFFER b-OpenCPedidos FOR ecommerce.OpenCPedidos.

FIND FacCfgGn WHERE FacCfgGn.CodCia = S-CODCIA NO-LOCK NO-ERROR.

DEFINE VAR x-ClientesVarios AS CHAR.
x-ClientesVarios = FacCfgGn.CliVar.     /* 11 digitos */

DEF VAR x-Articulo-ICBPer AS CHAR INIT '099268'.

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
      TABLE: ITEM T "SHARED" ? INTEGRAL FacDPedi
      TABLE: ITEM-LE T "?" ? INTEGRAL FacDPedi
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 4.77
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FIND b-FacCorre WHERE b-FacCorre.CodCia = S-CODCIA 
    AND b-FacCorre.CodDoc = S-CODDOC 
    AND b-FacCorre.NroSer = s-NroSer
    NO-LOCK NO-ERROR.
IF NOT AVAILABLE b-facCorre THEN DO:
    pMensaje = 'Cod.Doc(' + s-coddoc + ") y Nro Serie(" + STRING(s-nroser,"999") + ") " +
            "No estan configurados".
    RETURN 'ADM-ERROR'.
END.
IF b-FacCorre.FlgEst = NO THEN DO:
    pMensaje = 'Esta serie está bloqueada para hacer movimientos'.
    RETURN 'ADM-ERROR'.
END.
MESSAGE 'Seguro de realizar el proceso?' VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE rpta AS LOG.

IF rpta = NO THEN RETURN 'ADM-ERROR'.

DEFINE VAR x-codmat AS CHAR.
DEFINE VAR x-nroitm AS INT.

DEFINE VAR x-pedidos AS INT INIT 0.
DEFINE VAR x-rowid AS ROWID.

DEF VAR x-CanPed LIKE ITEM.canped NO-UNDO.
DEF VAR x-ImpLin LIKE ITEM.implin NO-UNDO.
DEF VAR x-ImpIgv LIKE ITEM.impigv NO-UNDO.
DEF VAR x-precio AS DEC.
DEF VAR x-precio-sin-igv AS DEC.

DEF VAR x-CuentaItems AS INT NO-UNDO.

/* Pedidos de ListaExpress Pendientes */
FOR EACH ecommerce.OpenCPedidos NO-LOCK WHERE ecommerce.OpenCPedidos.codcia = s-codcia AND
    ecommerce.OpenCPedidos.coddiv = s-coddiv AND
    ecommerce.OpenCPedidos.flagmigracion = '0' 
    BY ecommerce.OpenCPedidos.nroped :  
    IF x-pedidos = 0 THEN DO:
        x-rowid = ROWID(ecommerce.OpenCPedidos).
    END.
    x-pedidos = x-pedidos + 1.
END.
IF x-pedidos = 0 THEN DO:
    pMensaje = "No existen pedidos de ListaExpress".
    RETURN 'ADM-ERROR'.
END.
FIND FIRST ecommerce.OpenCPedidos WHERE ROWID(ecommerce.OpenCPedidos) = x-rowid NO-LOCK NO-ERROR.

SESSION:SET-WAIT-STATE('GENERAL').
LoopActualizarCotizacion:
DO TRANSACTION ON ERROR UNDO, LEAVE ON STOP UNDO, LEAVE :
    /* ******************************* */
    /* Creamos el cliente si no existe */
    /* ******************************* */
    RUN Registra-Cliente.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "NO se pudo crear el cliente".
        UNDO, LEAVE.
    END.
    /* AGREGA LA CABECERA DE LA COTIZACION */
    ASSIGN
        s-PorIgv = FacCfgGn.PorIgv.
    /* Adiciono el NUEVO REGISTRO */
    CREATE INTEGRAL.FacCPedi.
    ASSIGN
        s-CodMon = 1
        s-CodCli = ''
        s-FmaPgo = ''
        s-TpoCmb = 1
        s-NroDec = 4
        .
    ASSIGN 
        FacCPedi.CodMon = s-CodMon
        FacCPedi.Cmpbnte = "BOL"
        FacCPedi.Libre_d01  = s-NroDec
        FacCPedi.FlgIgv = YES.
    FIND TcmbCot WHERE  TcmbCot.Codcia = 0
        AND  (TcmbCot.Rango1 <= TODAY - TODAY + 1
              AND   TcmbCot.Rango2 >= TODAY - TODAY + 1)
        NO-LOCK NO-ERROR.
    IF AVAIL TcmbCot THEN S-TPOCMB = TcmbCot.TpoCmb.  
    /* RHC 11.08.2014 TC Caja Compra */
    FOR EACH gn-tccja NO-LOCK BY Fecha:
        IF TODAY >= Fecha THEN s-TpoCmb = Gn-TCCja.Compra.
    END.
    ASSIGN 
        FacCPedi.NroPed = STRING(b-FacCorre.NroSer, '999') + STRING(b-FacCorre.Correlativo, '999999')
        FacCPedi.FchPed = TODAY
        FacCPedi.FchVen = TODAY + s-MinimoDiasDespacho
        FacCPedi.TpoCmb = s-tpocmb
        FacCPedi.FchVen = TODAY + s-DiasVtoCot
        FacCPedi.FchEnt = ecommerce.OpenCPedidos.fchent
        Faccpedi.codven = s-CodVen
        FacCPedi.CodPos = ecommerce.OpenCPedidos.CodPos
        FacCPedi.ubigeo[2] = ecommerce.OpenCPedidos.coddept
        FacCPedi.ubigeo[3] = ecommerce.OpenCPedidos.codprov
        FacCPedi.ubigeo[4] = ecommerce.OpenCPedidos.coddist
        faccpedi.nroref = ecommerce.OpenCPedidos.nroped
        Faccpedi.ImpDto2 = 0 .
    ASSIGN 
        FacCPedi.Glosa = ecommerce.OpenCPedidos.glosa.
    /* ******************************** */
    /* RHC 26/05/2020 Datos Adicionales */
    /* ******************************** */
    ASSIGN
        INTEGRAL.FacCPedi.ordcmp = ecommerce.OpenCPedidos.NroRef
        INTEGRAL.FacCPedi.CustomerPurchaseOrder = ecommerce.OpenCPedidos.NroRef.
    /* ******************************** */
    /* */
    FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia
        AND gn-clie.codcli = ecommerce.OpenCPedidos.codcli
        NO-LOCK NO-ERROR.
    IF AVAILABLE gn-clie THEN DO:
        ASSIGN
            s-codcli = gn-clie.codcli
            Faccpedi.codcli = gn-clie.codcli
            FacCPedi.LugEnt = OpenCpedido.lugent.
        s-FmaPgo = '000'.
        ASSIGN 
            FacCPedi.FmaPgo = s-FmaPgo
            Faccpedi.NomCli = ecommerce.OpenCPedidos.Nomcli
            Faccpedi.DirCli = ecommerce.OpenCPedidos.DirCli
            Faccpedi.RucCli = ecommerce.OpenCPedidos.RucCli
            Faccpedi.Atencion = ecommerce.OpenCPedidos.DNICli
            /*Faccpedi.Glosa = lxCelular*/
            FacCPedi.NroCard = ""
            Faccpedi.CodVen = "021"
            Faccpedi.FaxCli = IF (AVAILABLE gn-clie) THEN SUBSTRING(TRIM(gn-clie.clfcli) + "00",1,2) +
                SUBSTRING(TRIM(gn-clie.clfcli2) + "00",1,2) ELSE ""
                    Faccpedi.Cmpbnte = 'BOL'.    
        DEF VAR pEstado AS LOG NO-UNDO.
        RUN sunat\p-inicio-actividades (INPUT TODAY, OUTPUT pEstado).
        IF pEstado = YES THEN DO:
            ASSIGN 
                Faccpedi.Cmpbnte = "BOL".
            IF Faccpedi.RucCli <> "" THEN Faccpedi.Cmpbnte = "FAC".
        END.
        /* ------------------------------ */
    END.
    EMPTY TEMP-TABLE ITEM.
    x-NroItm = 0.                
    /* Detalle del PEDIDO */
    FOR EACH ecommerce.OpenDPedido OF ecommerce.OpenCPedidos NO-LOCK:
        /* Buscar el codigo como interno */
        x-CodMat = ''.
        FIND FIRST Almmmatg WHERE almmmatg.codcia = s-codcia AND 
            almmmatg.Codmat = ecommerce.OpenDPedidos.codmat NO-LOCK NO-ERROR.
        x-CodMat = IF(AVAILABLE almmmatg) THEN almmmatg.codmat ELSE x-CodMat.
        IF AVAILABLE almmmatg  THEN DO:
            x-NroItm = x-NroItm + 1.
        END.
        CREATE ITEM.
        ASSIGN 
            ITEM.CodCia = s-codcia
            ITEM.codmat = x-CodMat
            ITEM.libre_c05 = ecommerce.OpenDPedidos.DescWeb
            ITEM.Factor = ecommerce.OpenDPedidos.factor 
            ITEM.CanPed = ecommerce.OpenDPedidos.Canped
            ITEM.NroItm = x-NroItm 
            ITEM.UndVta = ecommerce.OpenDPedidos.UndVta
            ITEM.ALMDES = S-CODALM
            ITEM.AftIgv = ecommerce.OpenDPedidos.AftIgv   /*(IF x-ImpIgv > 0 THEN YES ELSE NO)*/
            ITEM.ImpIgv = ecommerce.OpenDPedidos.ImpIgv
            ITEM.ImpLin = ecommerce.OpenDPedidos.ImpLin + ecommerce.OpenDPedidos.ImpDto2
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
    /* ********************************************************************** */
    /* RHC 14/11/2019 Los items de la cabecera deben coincidir con el detalle */
    /* ********************************************************************** */
    x-CuentaItems = 0.
    FOR EACH ITEM NO-LOCK:
        x-CuentaItems = x-CuentaItems + 1.
    END.
    IF ecommerce.OpenCPedidos.items <> x-CuentaItems THEN DO:
        pMensaje = "ERROR en la cantidad de items declarados en el pedido" + CHR(10) +
            "Documento: " + ecommerce.OpenCPedidos.NroPed + " Items: " + STRING(ecommerce.OpenCPedidos.items) + chr(10) +
            "Contados: " + STRING(x-CuentaItems).
        UNDO, LEAVE LoopActualizarCotizacion.
    END.
    /* Ic - 26Dic2017 , Flete (Costo de envio) */
    IF ecommerce.OpenCPedidos.impfle > 0 THEN DO:
        /* Buscar el codigo como interno del FLETE */
        x-CodMat = '044939'.
        /* Se ubico el Codigo Interno  */
        FIND Almmmatg WHERE almmmatg.codcia = s-codcia
            AND Almmmatg.codmat = x-codmat
            AND Almmmatg.tpoart <> 'D'
            NO-LOCK NO-ERROR.
        IF AVAILABLE Almmmatg THEN DO:
            /* Cantidad pedida */
            x-CanPed = ecommerce.OpenCPedidos.impfle.
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
            /*x-Cargo-Orden = YES.*/
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
                ITEM.ALMDES = S-CODALM
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
    /* Marcar la Cabecera como trabajado */
    FIND FIRST b-OpenCPedidos OF ecommerce.OpenCPedidos NO-ERROR.
    IF AVAILABLE b-OpenCPedidos THEN DO:
        ASSIGN 
            b-OpenCPedidos.flagmigracion = '1'
            b-OpenCPedidos.MigFecha = TODAY
            b-OpenCPedidos.MigHora = STRING(TIME,"HH:MM:SS")
            b-OpenCPedidos.MigUsuario = s-user-id.
    END.
    /**/
    FOR EACH ITEM:
        CREATE ITEM-LE.
        BUFFER-COPY ITEM TO ITEM-LE .
    END.
    RUN ue-assign-statement.
    IF RETURN-VALUE = 'ADM-ERROR' THEN DO:
        pMensaje = "ERROR en el correlativo de la cotización".
        UNDO, LEAVE.
    END.
    /* FIN - Adiciono el NUEVO REGISTRO */
END.
RELEASE b-FacCorre.
SESSION:SET-WAIT-STATE('').

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-Registra-Cliente) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Registra-Cliente Procedure 
PROCEDURE Registra-Cliente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR cEvento AS CHAR INIT "CREATE" NO-UNDO.

IF ecommerce.OpenCPedidos.CodCli = x-ClientesVarios THEN RETURN.
FIND FIRST gn-clie WHERE gn-clie.codcia = cl-codcia 
    AND gn-clie.codcli = ecommerce.OpenCPedidos.CodCli
    NO-LOCK NO-ERROR.
IF AVAILABLE gn-clie THEN RETURN.
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
    NO-ERROR
    .
IF ERROR-STATUS:ERROR THEN DO:
    pMensaje = ERROR-STATUS:GET-MESSAGE(1).
    UNDO, RETURN 'ADM-ERROR'.
END.
IF gn-clie.codcli BEGINS '20' THEN gn-clie.Libre_C01   = "J".
IF gn-clie.codcli BEGINS '15' OR gn-clie.codcli BEGINS '17' THEN gn-clie.Libre_C01   = "E".

RUN lib/logtabla ("gn-clie", STRING(gn-clie.codcia, '999') + '|' +
                  STRING(gn-clie.codcli, 'x(11)'), cEvento).

RELEASE gn-clie.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ue-assign-statement) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ue-assign-statement Procedure 
PROCEDURE ue-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DEFINE VARIABLE I-NITEM AS INTEGER NO-UNDO INIT 0.
  DEFINE VAR lCodCli AS CHAR.

  DEFINE BUFFER B-CPEDI FOR FacCPedi.

  {vta2/icorrelativosecuencial.i &Codigo = s-coddoc &Serie = s-nroser}

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
  IF ERROR-STATUS:ERROR THEN UNDO, RETURN 'ADM-ERROR'.
  IF s-TpoPed = "LF" THEN FacCPedi.FlgEst = "E".    /* Por Aprobar */

  lCodCli = FacCPedi.CodCli.

  ASSIGN
      FacCorre.Correlativo = FacCorre.Correlativo + 1.

  ASSIGN 
      FacCPedi.PorIgv = s-PorIgv
      FacCPedi.Hora = STRING(TIME,"HH:MM")
      FacCPedi.Usuario = S-USER-ID
      FacCPedi.Libre_c01 = pCodDiv.

  FOR EACH ITEM WHERE ITEM.ImpLin > 0,
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
  /* *************************************************** */
  /* Creamos una copia del pedido completo sin modificar */
  /* *************************************************** */
  CREATE B-CPEDI.
  BUFFER-COPY Faccpedi
      TO B-CPEDI
      ASSIGN B-CPEDI.CodDoc = "CLE".    /* Cotizacion Lista Express */
  I-NITEM = 0.
  FOR EACH ITEM-LE BY ITEM-LE.NroItm:
      I-NITEM = I-NITEM + 1.
      CREATE FacDPedi.
      BUFFER-COPY ITEM-LE
          TO FacDPedi
          ASSIGN
              FacDPedi.CodCia = B-CPEDI.CodCia
              FacDPedi.CodDiv = B-CPEDI.CodDiv
              FacDPedi.coddoc = B-CPEDI.coddoc
              FacDPedi.NroPed = B-CPEDI.NroPed
              FacDPedi.FchPed = B-CPEDI.FchPed
              FacDPedi.Hora   = B-CPEDI.Hora 
              FacDPedi.FlgEst = B-CPEDI.FlgEst
              FacDPedi.NroItm = I-NITEM.
  END.

/*   {vta2/graba-totales-cotizacion-cred.i} */
  {vtagn/totales-cotizacion-unificada.i &Cabecera="FacCPedi" &Detalle="FacDPedi"}

  /* **************** RHC 24.07.2014 MARGEN MINIMO POR DIVISION ****************** */
  DEF VAR pError AS CHAR.

  RUN vtagn/p-margen-utilidad-por-cotizacion ( ROWID(Faccpedi) , YES, OUTPUT pError ).
  IF pError = "ADM-ERROR" THEN ASSIGN Faccpedi.FlgEst = "T".
  IF Faccpedi.FlgEst = "T" AND pError = "OK" THEN ASSIGN Faccpedi.FlgEst = "P".    /* APROBADO */

  IF AVAILABLE(Faccorre) THEN RELEASE FacCorre.
  IF AVAILABLE(Facdpedi) THEN RELEASE Facdpedi.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

