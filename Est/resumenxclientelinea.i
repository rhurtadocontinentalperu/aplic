&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 5
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

FOR EACH VentasxClienteLinea NO-LOCK WHERE VentasxClienteLinea.DateKey >= DesdeF
    AND VentasxClienteLinea.DateKey <= HastaF
    AND (x-CodDiv = '' OR VentasxClienteLinea.coddiv = x-CodDiv)
    AND (x-CodFam = '' OR VentasxClienteLinea.codfam = x-CodFam)
    AND (x-CodCli = '' OR LOOKUP (VentasxClienteLinea.codcli, x-CodCli) > 0)
    AND (x-SubFam = '' OR VentasxClienteLinea.subfam = x-SubFam),
    FIRST DimFecha OF VentasxClienteLinea NO-LOCK:
/*     FIRST DimLinea OF VentasxClienteLinea NO-LOCK,    */
/*     FIRST DimSubLinea OF VentasxClienteLinea NO-LOCK, */
/*     FIRST DimCliente OF VentasxClienteLinea NO-LOCK:  */
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR CLIENTE Y PRODUCTO' + 
        ' FECHA ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (DimFecha.CalendarYear, '9999') +
        ' DIVISION ' + VentasxClienteLinea.coddiv + ' CLIENTE ' + VentasxClienteLinea.codcli + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        x-Llave = ''
        cCampania = ''
        cPeriodo = 0
        cNroMes = 0
        cDia = ?
        cDivision = ''
        cDestino = ''
        cCanalVenta = ''
        cProducto = ''
        cRanking = 0
        cCategoria = ''
        cLinea = ''
        cSublinea = ''
        cMarca = ''
        cUnidad = ''
        cLicencia = ''
        cLicenciatario = ''
        cProveedor = ''
        cCliente = ''
        cCliAcc = ''
        cCliUnico = ''
        cCanal = ''
        cGiro = ''
        cTarjeta = ''
        cDepartamento = ''
        cProvincia = ''
        cDistrito = ''
        cZona = ''
        cClasificacion = ''
        cTipo = ''
        cVendedor = ''
        cDelivery = ''
        cListaBase = ''.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cPeriodo  = YEAR(DimFecha.DateKey)
            cNroMes   = MONTH(DimFecha.DateKey).
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + DimFecha.DateDescription.
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cDia      = DimFecha.DateKey.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        FIND FIRST DimDivision OF VentasxClienteLinea NO-LOCK NO-ERROR.
        IF x-Llave = '' THEN x-Llave = VentasxClienteLinea.coddiv + '|'.
        ELSE x-Llave = x-LLave + VentasxClienteLinea.coddiv + '|'.
        x-Llave = x-Llave + (IF AVAILABLE DimDivision THEN DimDivision.CanalVenta ELSE '') + '|'.
        ASSIGN
            cDivision = VentasxClienteLinea.coddiv + ' ' + (IF AVAILABLE DimDivision THEN DimDivision.DesDiv ELSE '')
            cCanalVenta = (IF AVAILABLE DimDivision THEN DimDivision.CanalVenta + ' ' + DimDivision.NomCanalVenta ELSE '').
        FIND FIRST DimDivision WHERE DimDivision.coddiv =  VentasxClienteLinea.divdes NO-LOCK NO-ERROR.
        ASSIGN
            cDestino = VentasxClienteLinea.divdes + ' ' + (IF AVAILABLE DimDivision THEN DimDivision.DesDiv ELSE '')
            x-Llave = x-LLave + VentasxClienteLinea.divdes + '|'.
        ASSIGN
            cListaBase = VentasxClienteLinea.ListaBase
            x-Llave = x-LLave + VentasxClienteLinea.ListaBase + '|'.
         FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxClienteLinea.ListaBase NO-LOCK NO-ERROR.
         IF AVAILABLE DimDivision THEN cListaBase  = VentasxClienteLinea.ListaBase + ' ' + DimDivision.DesDiv.

    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
            x-Canal = ""
            x-Giro  = ""
            x-NroCard = ""
            x-CodDept = ""
            x-CodProv = ""
            x-CodDist = ""
            x-ClfCli = ""
            x-Zona = "".
        FIND FIRST DimCliente OF VentasxClienteLinea NO-LOCK NO-ERROR.
        IF AVAILABLE DimCliente THEN DO:
            FIND gn-clie WHERE gn-clie.codcia = cl-codcia
                AND gn-clie.codcli = DimCliente.CodCli
                NO-LOCK NO-ERROR.
            IF AVAILABLE gn-clie THEN cCliAcc = gn-clie.JfeLog[5].
            ASSIGN
                x-Canal = DimCliente.canal
                x-Giro  = DimCliente.gircli
                x-NroCard = ""
                x-CodDept = DimCliente.coddept
                x-CodProv = DimCliente.codprov
                x-CodDist = DimCliente.coddist
                x-ClfCli = DimCliente.clfcli
                x-Zona = "".
        END.
        IF TOGGLE-Resumen-Depto = NO THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxClienteLinea.codcli + '|'.
            ELSE x-Llave = x-Llave + VentasxClienteLinea.codcli + '|'.
            ASSIGN
                cCliente = VentasxClienteLinea.codcli + ' ' + (IF AVAILABLE DimCliente THEN DimCliente.NomCli ELSE "")
                cTarjeta = "".
            IF AVAILABLE DimCliente THEN DO:
                FIND B-Cliente WHERE B-Cliente.codcli = DimCliente.CodUnico NO-LOCK NO-ERROR.
                IF AVAILABLE B-Cliente THEN cCliUnico = DimCliente.CodCli + ' ' + DimCliente.NomCli.
            END.
        END.
        /* DEPARTAMENTO, PROVINCIA Y DISTRITO */
        IF AVAILABLE DimCliente THEN DO:
            FIND DimUbicacion WHERE DimUbicacion.CodDepto = DimCliente.CodDept 
                AND DimUbicacion.CodProvi = DimCliente.CodProv 
                AND DimUbicacion.CodDistr = DimCliente.CodDist
                NO-LOCK NO-ERROR.
            ASSIGN
                cCanal = DimCliente.Canal + ' ' + TRIM(DimCliente.NomCanal)
                cGiro  =  DimCliente.GirCli + ' ' + DimCliente.NomGirCli.
            IF AVAILABLE DimUbicacion THEN
                ASSIGN
                    cDepartamento = DimCliente.CodDept + ' ' + TRIM(DimUbicacion.NomDepto)
                    cProvincia = DimCliente.CodProv + ' ' + TRIM(DimUbicacion.Nomprovi)
                    cDistrito = DimCliente.CodDist + ' ' + TRIM(DimUbicacion.Nomdistr)
                    cZona = DimUbicacion.Zona + ' ' + TRIM(DimUbicacion.NomZona).
        END.
        /* CANAL */
        IF x-Llave = '' THEN x-Llave = x-canal + '|'.
        ELSE x-Llave = x-Llave + x-canal + '|'.
        x-Llave = x-Llave + x-coddept + '|'.
        x-Llave = x-Llave + x-codprov + '|'.
        x-Llave = x-Llave + x-coddist + '|'.
        x-Llave = x-Llave + x-zona + '|'.
        x-Llave = x-Llave + x-clfcli + '|'.
        x-Llave = x-Llave + VentasxClienteLinea.tipo + '|'.
    END.
     /* ******************************************** */
    IF TOGGLE-CodMat = YES THEN DO:
        FIND FIRST DimLinea OF VentasxClienteLinea NO-LOCK NO-ERROR.
        FIND FIRST DimSubLinea OF VentasxClienteLinea NO-LOCK NO-ERROR.
        IF TOGGLE-Resumen-Linea = YES THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxClienteLinea.codfam + '|'.
            ELSE x-Llave = x-Llave + VentasxClienteLinea.codfam + '|'.
            x-Llave = x-Llave + VentasxClienteLinea.subfam + '|'.
            ASSIGN
                cLinea = VentasxClienteLinea.codfam + ' ' + (IF AVAILABLE DimLinea THEN DimLinea.NomFam ELSE '').
            ASSIGN
                cSublinea = VentasxClienteLinea.subfam + ' ' + (IF AVAILABLE DimSubLinea THEN DimSubLinea.NomSubFam ELSE '').
        END.
        IF TOGGLE-Resumen-Solo-Linea = YES THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxClienteLinea.codfam + '|'.
            ELSE x-Llave = x-Llave + VentasxClienteLinea.codfam + '|'.
            ASSIGN
                cLinea = VentasxClienteLinea.codfam + ' ' + (IF AVAILABLE DimLinea THEN DimLinea.NomFam ELSE '').
        END.
        IF TOGGLE-Resumen-Marca = YES THEN DO:
            IF x-Llave = '' THEN x-Llave = VentasxClienteLinea.desmar + '|'.
            ELSE x-Llave = x-Llave + VentasxClienteLinea.desmar + '|'.
            ASSIGN
                cMarca = VentasxClienteLinea.desmar.
        END.
        x-Llave = x-Llave + VentasxClienteLinea.licencia + '|'.
        FIND DimLicencia WHERE DimLicencia.Licencia = VentasxClienteLinea.licencia NO-LOCK NO-ERROR.
        ASSIGN
             cLicencia = VentasxClienteLinea.licencia + (IF AVAILABLE DimLicencia THEN ' ' + DimLicencia.Descripcion ELSE '').
        IF AVAILABLE DimLicencia THEN DO:
            cLicenciatario = DimLicencia.Licenciatario.
            FIND DimLicenciatario OF DimLicencia NO-LOCK NO-ERROR.
            IF AVAILABLE DimLicenciatario THEN cLicenciatario = DimLicenciatario.Licenciatario + ' ' + DimLicenciatario.NomLicenciatario.
        END.
     END.
     ASSIGN
         x-Llave = x-Llave + VentasxClienteLinea.Tipo + '|'
         cTipo   = VentasxClienteLinea.Tipo
         cDelivery = VentasxClienteLinea.Delivery.
     /* ******************************************** */
     FIND Detalle WHERE Detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE Detalle THEN DO:
         CREATE Detalle.
         Detalle.llave = x-Llave.
     END.
     /* RHC 09/06/2015 */
     IF s-ConCostos = YES THEN RUN rResxClixLin (OUTPUT x-CostoNacCIGV, OUTPUT x-CostoExtCIGV).
     /* ************** */
     ASSIGN
         Detalle.Campania = cCampania
         Detalle.Periodo = cPeriodo
         Detalle.NroMes = cNroMes
         Detalle.Dia = cDia
         Detalle.Division = cDivision
         Detalle.Destino = cDestino
         Detalle.CanalVenta = cCanalVenta
         Detalle.Producto = cProducto
         Detalle.Linea = cLinea
         Detalle.Sublinea = cSublinea
         Detalle.Marca = cMarca
         Detalle.Unidad = cUnidad
         Detalle.Licencia = cLicencia
         Detalle.Licenciatario = cLicenciatario
         Detalle.Proveedor = cProveedor
         Detalle.Cliente = cCliente
         Detalle.CliAcc = cCliAcc
         Detalle.CliUnico = cCliUnico
         Detalle.Canal = cCanal
         Detalle.Giro  = cGiro
         Detalle.Tarjeta = cTarjeta
         Detalle.Departamento = cDepartamento
         Detalle.Provincia = cProvincia
         Detalle.Distrito = cDistrito
         Detalle.Zona = cZona 
         Detalle.Clasificacion = cClasificacion
         Detalle.Tipo = cTipo
         Detalle.Vendedor = cVendedor
         Detalle.Delivery = cDelivery
         Detalle.ListaBase = cListaBase
         /*Detalle.CanxMes   = Detalle.CanxMes   + VentasxClienteLinea.Cantidad*/
         Detalle.VtaxMesMe = Detalle.VtaxMesMe + VentasxClienteLinea.ImpExtCIGV
         Detalle.VtaxMesMn = Detalle.VtaxMesMn + VentasxClienteLinea.ImpNacCIGV
         Detalle.CtoxMesMe = Detalle.CtoxMesMe + x-CostoExtCIGV
         Detalle.CtoxMesMn = Detalle.CtoxMesMn + x-CostoNacCIGV
         Detalle.ProxMesMe = Detalle.ProxMesMe + VentasxClienteLinea.PromExtCIGV
         Detalle.ProxMesMn = Detalle.ProxMesMn + VentasxClienteLinea.PromNacCIGV.
     ASSIGN
         Detalle.ProxMesMe2 = Detalle.ProxMesMe2 + VentasxClienteLinea.PromExtSIGV
         Detalle.ProxMesMn2 = Detalle.ProxMesMn2 + VentasxClienteLinea.PromNacSIGV.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


