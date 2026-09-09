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

FOR EACH dwh_ventas NO-LOCK WHERE dwh_ventas.codcia = s-codcia
    AND dwh_ventas.fecha >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99") + STRING(DAY(DesdeF), "99"))
    AND dwh_ventas.fecha <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99") + STRING(DAY(HastaF), "99"))
    AND ( x-CodMat = '' OR LOOKUP (dwh_ventas.codmat, x-CodMat) > 0 )
    AND ( x-CodCli = '' OR LOOKUP (dwh_ventas.codcli, x-CodCli) > 0 )
    AND dwh_ventas.coddiv BEGINS x-CodDiv
    AND dwh_ventas.codven BEGINS x-CodVen,
    FIRST dwh_Division OF dwh_ventas NO-LOCK,
    FIRST dwh_Vendedor OF dwh_ventas NO-LOCK,
    FIRST dwh_Cliente NO-LOCK WHERE dwh_Cliente.codcia = cl-codcia AND dwh_Cliente.codcli = dwh_ventas.codcli,
    FIRST dwh_tiempo NO-LOCK WHERE dwh_tiempo.codcia = s-codcia AND dwh_tiempo.fecha = dwh_ventas.fecha,
    FIRST dwh_Productos OF dwh_ventas NO-LOCK WHERE dwh_Productos.codfam BEGINS x-CodFam
        AND dwh_Productos.CodPro[1] BEGINS x-CodPro
        AND dwh_Productos.subfam BEGINS x-SubFam:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA GENERAL ' + 
        ' FECHA ' + STRING (dwh_Tiempo.NroDia, '99') +
        ' ' + dwh_Tiempo.NombreMes + ' ' + STRING (dwh_Tiempo.Periodo, '9999') +
        ' DIVISION ' + dwh_ventas.coddiv + ' CLIENTE ' + dwh_ventas.codcli + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        x-Llave = ''
        cCampania = ''
        cPeriodo = 0
        cNroMes = 0
        cDia = ?
        cDivision = ''
        cCanalVenta = ''
        cProducto = ''
        cLinea = ''
        cSublinea = ''
        cMarca = ''
        cUnidad = ''
        cLicencia = ''
        cProveedor = ''
        cCliente = ''
        cCanal = ''
        cTarjeta = ''
        cDepartamento = ''
        cProvincia = ''
        cDistrito = ''
        cZona = ''
        cClasificacion = ''
        cTipo = ''
        cVendedor = ''
        lOptions = "FieldList:".
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroMes, '99').      /*dwh_Tiempo.NombreMes. */
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = dwh_Tiempo.Campania
            cPeriodo  = dwh_Tiempo.Periodo
            cNroMes   = dwh_Tiempo.NroMes
            lOptions = lOptions + 'Campania,Periodo,Nromes'.
    END.
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroDia, '99') + '/' +  
                            STRING(dwh_Tiempo.NroMes, '99') + '/' +
                            STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-LLave + '|'.
        ASSIGN
            cCampania = dwh_Tiempo.Campania
            cDia      = DATE (STRING(dwh_Tiempo.NroDia, '99') + '/' +  
                            STRING(dwh_Tiempo.NroMes, '99') + '/' +
                            STRING(dwh_Tiempo.Periodo, '9999') ).
            lOptions = lOptions + 'Campania,Dia'.
    END.
    IF TOGGLE-CodDiv = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas.coddiv + '|'.
         ELSE x-Llave = x-LLave + dwh_ventas.coddiv + '|'.
         x-Llave = x-Llave + dwh_Division.CanalVenta + '|'.
         ASSIGN
             cDivision = dwh_ventas.coddiv + ' ' + dwh_Division.DesDiv
             cCanalVenta = dwh_Division.CanalVenta + ' ' + dwh_Division.NomCanalVenta
             lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Division,CanalVenta'.
                                
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
            x-Canal = dwh_Cliente.canal
            x-Giro = dwh_Cliente.gircli
            x-NroCard = ""
            x-CodDept = dwh_Cliente.coddept
            x-CodProv = dwh_Cliente.codprov
            x-CodDist = dwh_Cliente.coddist
            x-ClfCli = dwh_Cliente.clfcli
            x-Zona = "".
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = dwh_ventas.codcli.
             ELSE x-Llave = x-Llave + dwh_ventas.codcli.
             x-Llave = x-Llave + '|' +  x-nrocard + '|'.
             ASSIGN
                 cCliente = dwh_ventas.codcli + ' ' + dwh_Cliente.NomCli
                 cTarjeta = dwh_Cliente.NroCard + ' ' + TRIM(dwh_Cliente.NomNroCard)
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Cliente,Tarjeta'.
        END.
        /* DEPARTAMENTO, PROVINCIA Y DISTRITO */
        FIND dwh_Ubicacion WHERE  dwh_Ubicacion.CodCia = s-codcia
            AND dwh_Ubicacion.CodDepto = dwh_Cliente.CodDept 
            AND dwh_Ubicacion.CodProvi = dwh_Cliente.CodProv 
            AND dwh_Ubicacion.CodDistr = dwh_Cliente.CodDist
            NO-LOCK NO-ERROR.
        /* CANAL */
        IF x-Llave = '' THEN x-Llave = x-canal + '|'.
        ELSE x-Llave = x-Llave + x-canal + '|'.
        x-Llave = x-Llave + x-coddept + '|'.
        x-Llave = x-Llave + x-codprov + '|'.
        x-Llave = x-Llave + x-coddist + '|'.
        x-Llave = x-Llave + x-zona + '|'.
        x-Llave = x-Llave + x-clfcli + '|'.
        x-Llave = x-Llave + dwh_ventas.tipo + '|'.
        ASSIGN
            cCanal = dwh_Cliente.Canal + ' ' + TRIM(dwh_Cliente.NomCanal)
            cTipo = dwh_ventas.tipo
            lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Canal,Tipo'.
        IF AVAILABLE dwh_Ubicacion THEN
            ASSIGN
                cDepartamento = dwh_Cliente.CodDept + ' ' + TRIM(dwh_Ubicacion.NomDepto)
                cProvincia = dwh_Cliente.CodProv + ' ' + TRIM(dwh_Ubicacion.Nomprovi)
                cDistrito = dwh_Cliente.CodDist + ' ' + TRIM(dwh_Ubicacion.Nomdistr)
                cZona = dwh_Ubicacion.Zona + ' ' + TRIM(dwh_Ubicacion.NomZona)
                lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Departamento,Provincia,Distrito,Zona'.
    END.
     /* ******************************************** */
    IF TOGGLE-CodMat = YES THEN DO:
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = dwh_ventas.codmat.
             ELSE x-Llave = x-Llave + dwh_ventas.codmat.
             x-Llave = x-Llave + dwh_Producto.codfam + '|'.
             x-Llave = x-Llave + dwh_Producto.subfam + '|'.
             x-Llave = x-Llave + dwh_Producto.desmar + '|'.
             x-Llave = x-Llave + dwh_Producto.undbas + '|'.
             ASSIGN
                 cProducto = dwh_ventas.codmat + ' ' + dwh_Productos.DesMat
                 cLinea = dwh_Producto.codfam + ' ' + dwh_Productos.NomFam 
                 cSublinea = dwh_Producto.subfam + ' ' + dwh_Productos.NomSubFam 
                 cMarca = dwh_Producto.desmar
                 cUnidad = dwh_Producto.undbas
                 lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                            'Producto,Linea,Sublinea,Marca,Unidad'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = dwh_Producto.codfam + '|'.
                 ELSE x-Llave = x-Llave + dwh_Producto.codfam + '|'.
                 x-Llave = x-Llave + dwh_Producto.subfam + '|'.
                 ASSIGN
                     cLinea = dwh_Producto.codfam + ' ' + dwh_Productos.NomFam 
                     cSublinea = dwh_Producto.subfam + ' ' + dwh_Productos.NomSubFam
                     lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                                'Linea,Sublinea'.

             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = dwh_Producto.desmar + '|'.
                 ELSE x-Llave = x-Llave + dwh_Producto.desmar + '|'.
                 ASSIGN
                     cMarca = dwh_Producto.desmar
                     lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                                'Marca'.
             END.
         END.
         x-Llave = x-Llave + dwh_Producto.licencia + '|'.
         x-Llave = x-Llave + dwh_Producto.codpro[1] + '|'.
         ASSIGN
             cLicencia = dwh_Producto.licencia + ' ' + dwh_Productos.NomLicencia
             cProveedor = dwh_Producto.codpro[1] + ' ' + dwh_Productos.NomPro[1]
             lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Licencia,Proveedor'.

     END.
     /* ******************************************** */
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas.codven + '|'.
         ELSE x-Llave = x-Llave + dwh_ventas.codven + '|'.
         ASSIGN
             cVendedor = dwh_ventas.codven + ' ' + dwh_Vendedor.NomVen
             lOptions = lOptions + (IF SUBSTRING(lOptions, LENGTH(lOptions), 1) = ':' THEN '' ELSE ',') +
                        'Vendedor'.
     END.
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
         Detalle.CanalVenta = cCanalVenta
         Detalle.Producto = cProducto
         Detalle.Linea = cLinea
         Detalle.Sublinea = cSublinea
         Detalle.Marca = cMarca
         Detalle.Unidad = cUnidad
         Detalle.Licencia = cLicencia
         Detalle.Proveedor = cProveedor
         Detalle.Cliente = cCliente
         Detalle.Canal = cCanal
         Detalle.Tarjeta = cTarjeta
         Detalle.Departamento = cDepartamento
         Detalle.Provincia = cProvincia
         Detalle.Distrito = cDistrito
         Detalle.Zona = cZona 
         Detalle.Clasificacion = cClasificacion
         Detalle.Tipo = cTipo
         Detalle.Vendedor = cVendedor
         Detalle.CanxMes   = Detalle.CanxMes   + dwh_Ventas.Cantidad
         Detalle.VtaxMesMe = Detalle.VtaxMesMe + dwh_Ventas.ImpExtCIGV
         Detalle.VtaxMesMn = Detalle.VtaxMesMn + dwh_Ventas.ImpNacCIGV
         Detalle.CtoxMesMe = Detalle.CtoxMesMe + dwh_Ventas.CostoExtCIGV
         Detalle.CtoxMesMn = Detalle.CtoxMesMn + dwh_Ventas.CostoNacCIGV
         Detalle.ProxMesMe = Detalle.ProxMesMe + dwh_Ventas.PromExtCIGV
         Detalle.ProxMesMn = Detalle.ProxMesMn + dwh_Ventas.PromNacCIGV.
END.

ASSIGN
    pOptions = pOptions + CHR(1) + lOptions.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


