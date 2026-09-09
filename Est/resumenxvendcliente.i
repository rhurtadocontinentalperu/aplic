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
         HEIGHT             = 4.35
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */


FOR EACH VentasxVendCliente NO-LOCK WHERE VentasxVendCliente.DateKey >= DesdeF
    AND VentasxVendCliente.DateKey <= HastaF
    AND (x-CodCli = '' OR LOOKUP (VentasxVendCliente.codcli, x-CodCli) > 0)
    AND (x-CodDiv = '' OR VentasxVendCliente.coddiv = x-CodDiv)
    AND (x-CodVen = '' OR VentasxVendCliente.codven = x-CodVen),
/*     FIRST DimVendedor OF VentasxVendCliente NO-LOCK, */
/*     FIRST DimCliente OF VentasxVendCliente NO-LOCK,  */
    FIRST DimFecha OF VentasxVendCliente NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR VENDEDOR Y CLIENTE ' + 
        ' Fecha ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (DimFecha.CalendarYear, '9999') +
        ' DIVISION ' + VentasxVendCliente.coddiv + ' CLIENTE ' + VentasxVendCliente.codcli + ' VENDEDOR ' + VentasxVendCliente.codven + ' **'.
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
        cLinea = ''
        cSublinea = ''
        cMarca = ''
        cUnidad = ''
        cLicencia = ''
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
        FIND FIRST DimDivision OF VentasxVendCliente NO-LOCK.
         IF x-Llave = '' THEN x-Llave = VentasxVendCliente.coddiv + '|'.
         ELSE x-Llave = x-LLave + VentasxVendCliente.coddiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + '|'.
         ASSIGN
             cDivision = VentasxVendCliente.coddiv + ' ' + DimDivision.DesDiv
             cCanalVenta = DimDivision.CanalVenta + ' ' + DimDivision.NomCanalVenta.
         FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxVendCliente.divdes NO-LOCK.
         ASSIGN
             cDestino = VentasxVendCliente.divdes + ' ' + DimDivision.DesDiv
             x-Llave = x-LLave + VentasxVendCliente.divdes + '|'.
         ASSIGN
             cListaBase = VentasxVendCliente.ListaBase
             x-Llave = x-LLave + VentasxVendCliente.ListaBase + '|'.
         FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxVendCliente.ListaBase NO-LOCK NO-ERROR.
         IF AVAILABLE DimDivision THEN cListaBase  = VentasxVendCliente.ListaBase + ' ' + DimDivision.DesDiv.

    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
            x-Canal = ""
            x-Giro = ""
            x-NroCard = ""
            x-CodDept = ""
            x-CodProv = ""
            x-CodDist = ""
            x-ClfCli = ""
            x-Zona = "".
        FIND FIRST DimCliente OF VentasxVendCliente NO-LOCK NO-ERROR.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = DimCliente.CodCli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN cCliAcc = gn-clie.JfeLog[5].
        IF AVAILABLE DimCliente THEN DO:
            ASSIGN
                x-Canal = DimCliente.canal
                x-Giro = DimCliente.gircli
                x-NroCard = ""
                x-CodDept = DimCliente.coddept
                x-CodProv = DimCliente.codprov
                x-CodDist = DimCliente.coddist
                x-ClfCli = DimCliente.clfcli
                x-Zona = "".
        END.
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = VentasxVendCliente.codcli.
             ELSE x-Llave = x-Llave + VentasxVendCliente.codcli.
             ASSIGN
                 cCliente = VentasxVendCliente.codcli + ' ' + (IF AVAILABLE DimCliente THEN DimCliente.NomCli ELSE "")
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
            /* CANAL */
            ASSIGN
                cCanal = DimCliente.Canal + ' ' + TRIM(DimCliente.NomCanal)
                cGiro  = DimCliente.GirCli + ' ' + DimCliente.NomGirCli.
            IF AVAILABLE DimUbicacion THEN
                ASSIGN
                    cDepartamento = DimCliente.CodDept + ' ' + TRIM(DimUbicacion.NomDepto)
                    cProvincia = DimCliente.CodProv + ' ' + TRIM(DimUbicacion.Nomprovi)
                    cDistrito = DimCliente.CodDist + ' ' + TRIM(DimUbicacion.Nomdistr)
                    cZona = DimUbicacion.Zona + ' ' + TRIM(DimUbicacion.NomZona).
        END.
        IF x-Llave = '' THEN x-Llave = x-canal + '|'.
        ELSE x-Llave = x-Llave + x-canal + '|'.
        x-Llave = x-Llave + x-coddept + '|'.
        x-Llave = x-Llave + x-codprov + '|'.
        x-Llave = x-Llave + x-coddist + '|'.
        x-Llave = x-Llave + x-zona + '|'.
        x-Llave = x-Llave + x-clfcli + '|'.
        x-Llave = x-Llave + VentasxVendCliente.tipo + '|'.
    END.
     /* ******************************************** */
     IF TOGGLE-CodVen = YES THEN DO:
         FIND FIRST DimVendedor OF VentasxVendCliente NO-LOCK NO-ERROR.
         IF x-Llave = '' THEN x-Llave = VentasxVendCliente.codven + '|'.
         ELSE x-Llave = x-Llave + VentasxVendCliente.codven + '|'.
         ASSIGN
             cVendedor = VentasxVendCliente.codven + ' ' + (IF AVAILABLE DimVendedor THEN DimVendedor.NomVen ELSE "").
     END.
     ASSIGN
         x-Llave = x-Llave + VentasxVendCliente.Tipo + '|'
         cTipo   = VentasxVendCliente.Tipo
         cDelivery = VentasxVendCliente.Delivery.
         
     /* ******************************************** */
     FIND Detalle WHERE Detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE Detalle THEN DO:
         CREATE Detalle.
         Detalle.llave = x-Llave.
     END.
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
         /*Detalle.CanxMes   = Detalle.CanxMes   + VentasxVendCliente.Cantidad*/
         Detalle.VtaxMesMe = Detalle.VtaxMesMe + VentasxVendCliente.ImpExtCIGV
         Detalle.VtaxMesMn = Detalle.VtaxMesMn + VentasxVendCliente.ImpNacCIGV
         Detalle.CtoxMesMe = Detalle.CtoxMesMe + VentasxVendCliente.CostoExtCIGV
         Detalle.CtoxMesMn = Detalle.CtoxMesMn + VentasxVendCliente.CostoNacCIGV
         Detalle.ProxMesMe = Detalle.ProxMesMe + VentasxVendCliente.PromExtCIGV
         Detalle.ProxMesMn = Detalle.ProxMesMn + VentasxVendCliente.PromNacCIGV.
     ASSIGN
         Detalle.ProxMesMe2 = Detalle.ProxMesMe2 + VentasxVendCliente.PromExtSIGV
         Detalle.ProxMesMn2 = Detalle.ProxMesMn2 + VentasxVendCliente.PromNacSIGV.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


