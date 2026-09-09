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
ASSIGN
    x-NroFchR = INTEGER( STRING(YEAR(DesdeF) - 1, '9999') + '0101')
    x-NroFchE = INTEGER( STRING(YEAR(HastaF), '9999') + STRING(MONTH(HastaF), '99') + '31').

FOR EACH dwh_ventas NO-LOCK WHERE dwh_ventas.codcia = s-codcia
    AND dwh_ventas.fecha >= x-NroFchR
    AND dwh_ventas.fecha <= x-NroFchE
    AND ( x-CodMat = '' OR LOOKUP (dwh_ventas.codmat, x-CodMat) > 0 )
    AND ( x-CodCli = '' OR LOOKUP (dwh_ventas.codcli, x-CodCli) > 0 )
    AND dwh_ventas.coddiv BEGINS x-CodDiv
    AND dwh_ventas.codven BEGINS x-CodVen,
    FIRST dwh_tiempo WHERE dwh_tiempo.codcia = s-codcia
    AND dwh_tiempo.fecha = dwh_ventas.fecha NO-LOCK,
    FIRST dwh_Division OF dwh_ventas NO-LOCK,
    FIRST dwh_Cliente NO-LOCK WHERE dwh_Cliente.codcia = cl-codcia AND dwh_Cliente.codcli = dwh_ventas.codcli,
    FIRST dwh_Producto OF dwh_ventas NO-LOCK WHERE dwh_Producto.codfam BEGINS x-CodFam
    AND dwh_Producto.CodPro[1] BEGINS x-CodPro
    AND dwh_Producto.subfam BEGINS x-SubFam:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA GENERAL ' + 
        ' FECHA ' + STRING (dwh_Tiempo.NroDia, '99') +
        ' ' + dwh_Tiempo.NombreMes + ' ' + STRING (dwh_Tiempo.Periodo, '9999') +
        ' DIVISION ' + dwh_ventas.coddiv + ' CLIENTE ' + dwh_ventas.codcli + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    ASSIGN
        T-Vtamn   = 0
        T-Vtame   = 0
        T-Ctomn   = 0
        T-Ctome   = 0
        T-Promn   = 0
        T-Prome   = 0
        F-Salida  = 0.
    x-Llave = ''.
    x-Fecha = DATE(SUBSTRING(STRING(dwh_ventas.fecha, '99999999'),7,2) + '/' +
                   SUBSTRING(STRING(dwh_ventas.fecha, '99999999'),5,2) + '/' +
                   SUBSTRING(STRING(dwh_ventas.fecha, '99999999'),1,4)).
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            F-Salida[1]  = F-Salida[1]  + dwh_Ventas.Cantidad
            T-Vtamn[1]   = T-Vtamn[1]   + dwh_Ventas.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + dwh_Ventas.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + dwh_Ventas.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + dwh_Ventas.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + dwh_Ventas.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + dwh_Ventas.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            F-Salida[2]  = F-Salida[2]  + dwh_Ventas.Cantidad
            T-Vtamn[2]   = T-Vtamn[2]   + dwh_Ventas.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + dwh_Ventas.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + dwh_Ventas.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + dwh_Ventas.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + dwh_Ventas.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + dwh_Ventas.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            F-Salida[3]  = F-Salida[3]  + dwh_Ventas.Cantidad
            T-Vtamn[3]   = T-Vtamn[3]   + dwh_Ventas.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + dwh_Ventas.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + dwh_Ventas.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + dwh_Ventas.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + dwh_Ventas.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + dwh_Ventas.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            F-Salida[4]  = F-Salida[4]  + dwh_Ventas.Cantidad
            T-Vtamn[4]   = T-Vtamn[4]   + dwh_Ventas.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + dwh_Ventas.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + dwh_Ventas.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + dwh_Ventas.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + dwh_Ventas.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + dwh_Ventas.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroMes, '99').      /*dwh_Tiempo.NombreMes. */
        x-Llave = x-LLave + '|'.
    END.
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas.coddiv.
         ELSE x-Llave = x-LLave + dwh_ventas.coddiv.
         x-Llave = x-Llave + ' - ' + dwh_Division.DesDiv + '|'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
            x-Canal = dwh_Cliente.canal
            x-Giro = dwh_Cliente.gircli
            x-NroCard = dwh_Cliente.nrocard
            x-CodDept = dwh_Cliente.coddept
            x-CodProv = dwh_Cliente.codprov
            x-CodDist = dwh_Cliente.coddist
            x-ClfCli = dwh_Cliente.clfcli
            x-Zona = "".
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = dwh_ventas.codcli.
             ELSE x-Llave = x-Llave + dwh_ventas.codcli.
             x-Llave = x-Llave + ' - ' + dwh_Cliente.NomCli + '|'.
        END.
        /* CANAL CLIENTE */
        x-Canal = dwh_Cliente.Canal + ' - ' + TRIM(dwh_Cliente.NomCanal).
        /* GIRO DEL NEGOCIO */
        x-Giro = dwh_Cliente.GirCli + ' - ' + TRIM(dwh_Cliente.NomGirCli).
        /* Tarjeta Cliente Exclusivo */
        x-NroCard = dwh_Cliente.NroCard + ' - ' + TRIM(dwh_Cliente.NomNroCard).
        /* DEPARTAMENTO, PROVINCIA Y DISTRITO */
        FIND dwh_Ubicacion WHERE  dwh_Ubicacion.CodCia = s-codcia
            AND dwh_Ubicacion.CodDepto = dwh_Cliente.CodDept 
            AND dwh_Ubicacion.CodProvi = dwh_Cliente.CodProv 
            AND dwh_Ubicacion.CodDistr = dwh_Cliente.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE dwh_Ubicacion 
            THEN ASSIGN
                    x-CodDept = dwh_Cliente.CodDept + ' - ' + TRIM(dwh_Ubicacion.NomDepto)
                    x-CodProv = dwh_Cliente.CodProv + ' - ' + TRIM(dwh_Ubicacion.Nomprovi)
                    x-CodDist = dwh_Cliente.CodDist + ' - ' + TRIM(dwh_Ubicacion.Nomdistr)
                    x-Zona = dwh_Ubicacion.Zona + ' - ' + TRIM(dwh_Ubicacion.NomZona).
        /* CANAL */
        IF x-Llave = '' THEN x-Llave = x-canal + '|'.
        ELSE x-Llave = x-Llave + x-canal + '|'.
        /*x-Llave = x-Llave + x-giro + '|'.*/
        x-Llave = x-Llave + x-nrocard + '|'.
        x-Llave = x-Llave + x-coddept + '|'.
        x-Llave = x-Llave + x-codprov + '|'.
        x-Llave = x-Llave + x-coddist + '|'.
        x-Llave = x-Llave + x-zona + '|'.
        x-Llave = x-Llave + x-clfcli + '|'.
    END.
    IF TOGGLE-CodMat = YES THEN DO:
        IF (TOGGLE-Resumen-Linea = NO AND TOGGLE-Resumen-Marca = NO) THEN DO:
             IF x-Llave = '' THEN x-Llave = trim(dwh_ventas.codmat).
             ELSE x-Llave = x-Llave + trim(dwh_ventas.codmat).
             x-Llave = x-Llave + ' - ' + dwh_Productos.DesMat + '|'.
             x-Llave = x-Llave + dwh_Producto.codfam + ' - ' + dwh_Productos.NomFam + '|'.
             x-Llave = x-Llave + dwh_Producto.subfam + ' - ' + dwh_Productos.NomSubFam + '|'.
             x-Llave = x-Llave + dwh_Producto.desmar + '|'.
             x-Llave = x-Llave + dwh_Producto.undbas + '|'.
         END.
         ELSE DO:
             IF TOGGLE-Resumen-Linea = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = dwh_Producto.codfam + ' - ' + dwh_Productos.NomFam + '|'.
                 ELSE x-Llave = x-Llave + dwh_Producto.codfam + ' - ' + dwh_Productos.NomFam + '|'.
                 x-Llave = x-Llave + dwh_Producto.subfam + ' - ' + dwh_Productos.NomSubFam + '|'.
             END.
             IF TOGGLE-Resumen-Marca = YES THEN DO:
                 IF x-Llave = '' THEN x-Llave = dwh_Producto.desmar + '|'.
                 ELSE x-Llave = x-Llave + dwh_Producto.desmar + '|'.
             END.
         END.
         x-Llave = x-Llave + dwh_Producto.licencia + ' - ' + dwh_Productos.NomLicencia + '|'.
         x-Llave = x-Llave + dwh_Producto.codpro[1] + ' - ' + dwh_Productos.NomPro[1] + '|'.
     END.
     /* ******************************************** */
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas.codven + ' - ' + dwh_Vendedor.NomVen + '|'.
         ELSE x-Llave = x-Llave + dwh_ventas.codven + ' - ' + dwh_Vendedor.NomVen + '|'.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.CanxMes[1]   = tmp-detalle.CanxMes[1]   + f-Salida[1]
         tmp-detalle.VtaxMesMe[1] = tmp-detalle.VtaxMesMe[1] + T-Vtame[1]
         tmp-detalle.VtaxMesMn[1] = tmp-detalle.VtaxMesMn[1] + T-Vtamn[1]
         tmp-detalle.CtoxMesMe[1] = tmp-detalle.CtoxMesMe[1] + T-Ctome[1]
         tmp-detalle.CtoxMesMn[1] = tmp-detalle.CtoxMesMn[1] + T-Ctomn[1]
         tmp-detalle.ProxMesMe[1] = tmp-detalle.ProxMesMe[1] + T-Prome[1]
         tmp-detalle.ProxMesMn[1] = tmp-detalle.ProxMesMn[1] + T-Promn[1]
         tmp-detalle.CanxMes[2]   = tmp-detalle.CanxMes[2]   + f-Salida[2]
         tmp-detalle.VtaxMesMe[2] = tmp-detalle.VtaxMesMe[2] + T-Vtame[2]
         tmp-detalle.VtaxMesMn[2] = tmp-detalle.VtaxMesMn[2] + T-Vtamn[2]
         tmp-detalle.CtoxMesMe[2] = tmp-detalle.CtoxMesMe[2] + T-Ctome[2]
         tmp-detalle.CtoxMesMn[2] = tmp-detalle.CtoxMesMn[2] + T-Ctomn[2]
         tmp-detalle.ProxMesMe[2] = tmp-detalle.ProxMesMe[2] + T-Prome[2]
         tmp-detalle.ProxMesMn[2] = tmp-detalle.ProxMesMn[2] + T-Promn[2]
         tmp-detalle.CanxMes[3]   = tmp-detalle.CanxMes[3]   + f-Salida[3]
         tmp-detalle.VtaxMesMe[3] = tmp-detalle.VtaxMesMe[3] + T-Vtame[3]
         tmp-detalle.VtaxMesMn[3] = tmp-detalle.VtaxMesMn[3] + T-Vtamn[3]
         tmp-detalle.CtoxMesMe[3] = tmp-detalle.CtoxMesMe[3] + T-Ctome[3]
         tmp-detalle.CtoxMesMn[3] = tmp-detalle.CtoxMesMn[3] + T-Ctomn[3]
         tmp-detalle.ProxMesMe[3] = tmp-detalle.ProxMesMe[3] + T-Prome[3]
         tmp-detalle.ProxMesMn[3] = tmp-detalle.ProxMesMn[3] + T-Promn[3]
         tmp-detalle.CanxMes[4]   = tmp-detalle.CanxMes[4]   + f-Salida[4]
         tmp-detalle.VtaxMesMe[4] = tmp-detalle.VtaxMesMe[4] + T-Vtame[4]
         tmp-detalle.VtaxMesMn[4] = tmp-detalle.VtaxMesMn[4] + T-Vtamn[4]
         tmp-detalle.CtoxMesMe[4] = tmp-detalle.CtoxMesMe[4] + T-Ctome[4]
         tmp-detalle.CtoxMesMn[4] = tmp-detalle.CtoxMesMn[4] + T-Ctomn[4]
         tmp-detalle.ProxMesMe[4] = tmp-detalle.ProxMesMe[4] + T-Prome[4]
         tmp-detalle.ProxMesMn[4] = tmp-detalle.ProxMesMn[4] + T-Promn[4].
END.

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


