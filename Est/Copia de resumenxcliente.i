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
         HEIGHT             = 4.23
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

FOR EACH VentasxCliente NO-LOCK WHERE VentasxCliente.DateKey >= DesdeF
    AND VentasxCliente.DateKey <= HastaF
    AND (x-CodCli = '' OR LOOKUP (VentasxCliente.codcli, x-CodCli) > 0)
    AND (x-CodDiv = '' OR VentasxCliente.coddiv = x-CodDiv),
    FIRST DimCliente OF VentasxCliente NO-LOCK,
    FIRST DimFecha OF VentasxCliente NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR CLIENTE ' + 
        ' Fecha ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (DimFecha.CalendarYear, '9999') +
        ' DIVISION ' + VentasxCliente.coddiv + ' CLIENTE ' + VentasxCliente.codcli + ' **'.
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
        cCliUnico = ''
        cCanal = ''
        cTarjeta = ''
        cDepartamento = ''
        cProvincia = ''
        cDistrito = ''
        cZona = ''
        cClasificacion = ''
        cTipo = ''
        cVendedor = ''
        cDelivery = ''
        lOptions = "FieldList:".
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
            cNroMes   = MONTH(DimFecha.DateKey)
            lOptions = lOptions + 'Campania,Periodo,Nromes'.
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = DimFecha.Campania.
        ELSE x-Llave = x-Llave + DimFecha.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + DimFecha.DateDescription.
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = DimFecha.Campania
            cDia      = DimFecha.DateKey
            lOptions = lOptions + 'Campania,Dia'.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
        FIND FIRST DimDivision OF VentasxCliente NO-LOCK.
         IF x-Llave = '' THEN x-Llave = VentasxCliente.coddiv + '|'.
         ELSE x-Llave = x-LLave + VentasxCliente.coddiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + '|'.
         ASSIGN
             cDivision = VentasxCliente.coddiv + ' ' + DimDivision.DesDiv
             cCanalVenta = DimDivision.CanalVenta + ' ' + DimDivision.NomCanalVenta.
         FIND FIRST DimDivision WHERE DimDivision.coddiv = VentasxCliente.divdes NO-LOCK.
         ASSIGN
             cDestino = VentasxCliente.divdes + ' ' + DimDivision.DesDiv
             x-Llave = x-LLave + VentasxCliente.divdes + '|'.
         ASSIGN
             lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Division,Destino,CanalVenta'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
            x-Canal = DimCliente.canal
            x-Giro = DimCliente.gircli
            x-NroCard = ""
            x-CodDept = DimCliente.coddept
            x-CodProv = DimCliente.codprov
            x-CodDist = DimCliente.coddist
            x-ClfCli = DimCliente.clfcli
            x-Zona = "".
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = VentasxCliente.codcli.
             ELSE x-Llave = x-Llave + VentasxCliente.codcli.
             ASSIGN
                 cCliente = VentasxCliente.codcli + ' ' + DimCliente.NomCli
                 cTarjeta = ""
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Cliente'.
            FIND B-Cliente WHERE B-Cliente.codcli = DimCliente.CodUnico NO-LOCK NO-ERROR.
            IF AVAILABLE B-Cliente THEN cCliUnico = DimCliente.CodCli + ' ' + DimCliente.NomCli.
            ASSIGN
                lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'CliUnico'.
        END.
        /* DEPARTAMENTO, PROVINCIA Y DISTRITO */
        FIND DimUbicacion WHERE DimUbicacion.CodDepto = DimCliente.CodDept 
            AND DimUbicacion.CodProvi = DimCliente.CodProv 
            AND DimUbicacion.CodDistr = DimCliente.CodDist
            NO-LOCK NO-ERROR.
        /* CANAL */
        IF x-Llave = '' THEN x-Llave = x-canal + '|'.
        ELSE x-Llave = x-Llave + x-canal + '|'.
        x-Llave = x-Llave + x-coddept + '|'.
        x-Llave = x-Llave + x-codprov + '|'.
        x-Llave = x-Llave + x-coddist + '|'.
        x-Llave = x-Llave + x-zona + '|'.
        x-Llave = x-Llave + x-clfcli + '|'.
        x-Llave = x-Llave + VentasxCliente.tipo + '|'.
        ASSIGN
            cCanal = DimCliente.Canal + ' ' + TRIM(DimCliente.NomCanal)
            lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Canal'.
        IF AVAILABLE DimUbicacion THEN
            ASSIGN
                cDepartamento = DimCliente.CodDept + ' ' + TRIM(DimUbicacion.NomDepto)
                cProvincia = DimCliente.CodProv + ' ' + TRIM(DimUbicacion.Nomprovi)
                cDistrito = DimCliente.CodDist + ' ' + TRIM(DimUbicacion.Nomdistr)
                cZona = DimUbicacion.Zona + ' ' + TRIM(DimUbicacion.NomZona)
                lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Departamento,Provincia,Distrito,Zona'.
    END.
    ASSIGN
        x-Llave = x-Llave + VentasxCliente.Tipo + '|'
        cTipo   = VentasxCliente.Tipo
        cDelivery = VentasxCliente.Delivery
        lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                    'Tipo'.
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
         Detalle.Destino  = cDestino
         Detalle.CanalVenta = cCanalVenta
         Detalle.Producto = cProducto
         Detalle.Linea = cLinea
         Detalle.Sublinea = cSublinea
         Detalle.Marca = cMarca
         Detalle.Unidad = cUnidad
         Detalle.Licencia = cLicencia
         Detalle.Proveedor = cProveedor
         Detalle.Cliente = cCliente
         Detalle.CliUnico = cCliUnico
         Detalle.Canal = cCanal
         Detalle.Tarjeta = cTarjeta
         Detalle.Departamento = cDepartamento
         Detalle.Provincia = cProvincia
         Detalle.Distrito = cDistrito
         Detalle.Zona = cZona 
         Detalle.Clasificacion = cClasificacion
         Detalle.Tipo = cTipo
         Detalle.Vendedor = cVendedor
         Detalle.Delivery = cDelivery
         Detalle.VtaxMesMe = Detalle.VtaxMesMe + VentasxCliente.ImpExtCIGV
         Detalle.VtaxMesMn = Detalle.VtaxMesMn + VentasxCliente.ImpNacCIGV
         Detalle.CtoxMesMe = Detalle.CtoxMesMe + VentasxCliente.CostoExtCIGV
         Detalle.CtoxMesMn = Detalle.CtoxMesMn + VentasxCliente.CostoNacCIGV
         Detalle.ProxMesMe = Detalle.ProxMesMe + VentasxCliente.PromExtCIGV
         Detalle.ProxMesMn = Detalle.ProxMesMn + VentasxCliente.PromNacCIGV.
END.

/* ASSIGN                                       */
/*     pOptions = pOptions + CHR(1) + lOptions. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


