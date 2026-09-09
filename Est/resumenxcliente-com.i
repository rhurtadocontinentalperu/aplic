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
/* ASSIGN                                         */
/*     x-NroFchR = DATE(01, 01, YEAR(DesdeF) - 1) */
/*     x-NroFchE = HastaF.                        */

FOR EACH VentasxCliente NO-LOCK WHERE VentasxCliente.DateKey >= x-NroFchR
    AND VentasxCliente.DateKey <= x-NroFchE
    AND (x-CodCli = '' OR LOOKUP (VentasxCliente.codcli, x-CodCli) > 0)
    AND (x-CodDiv = '' OR VentasxCliente.coddiv = x-CodDiv),
    FIRST DimFecha NO-LOCK WHERE DimFecha.DateKey = VentasxCliente.DateKey,
    FIRST DimDivision OF VentasxCliente NO-LOCK,
    FIRST DimCliente NO-LOCK WHERE DimCliente.CodCli = VentasxCliente.CodCli:

    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR CLIENTE ' + 
        ' FECHA ' + STRING (DAY(DimFecha.DateKey), '99') +
        ' ' + DimFecha.CalendarMonthLabel + ' ' + STRING (YEAR(DimFecha.DateKey), '9999') +
        ' DIVISION ' + VentasxCliente.coddiv + ' CLIENTE ' + VentasxCliente.codcli + ' **'.
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
    x-Fecha = VentasxCliente.DateKey.
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[1]  = F-Salida[1]  + VentasxCliente.Cantidad*/
            T-Vtamn[1]   = T-Vtamn[1]   + VentasxCliente.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + VentasxCliente.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + VentasxCliente.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + VentasxCliente.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + VentasxCliente.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + VentasxCliente.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[2]  = F-Salida[2]  + VentasxCliente.Cantidad*/
            T-Vtamn[2]   = T-Vtamn[2]   + VentasxCliente.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + VentasxCliente.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + VentasxCliente.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + VentasxCliente.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + VentasxCliente.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + VentasxCliente.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[3]  = F-Salida[3]  + VentasxCliente.Cantidad*/
            T-Vtamn[3]   = T-Vtamn[3]   + VentasxCliente.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + VentasxCliente.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + VentasxCliente.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + VentasxCliente.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + VentasxCliente.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + VentasxCliente.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[4]  = F-Salida[4]  + VentasxCliente.Cantidad*/
            T-Vtamn[4]   = T-Vtamn[4]   + VentasxCliente.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + VentasxCliente.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + VentasxCliente.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + VentasxCliente.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + VentasxCliente.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + VentasxCliente.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
/*     IF RADIO-SET-Tipo = 2 THEN DO:                                                              */
/*         IF x-Llave = '' THEN x-Llave = DimFecha.Campania.                                       */
/*         ELSE x-Llave = x-Llave + DimFecha.Campania.                                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(YEAR(DimFecha.DateKey), '9999').                             */
/*         x-Llave = x-Llave + '|'.                                                                */
/*         x-Llave = x-Llave + STRING(MONTH(DimFecha.DateKey), '99').      /*DimFecha.NombreMes.*/ */
/*         x-Llave = x-LLave + '|'.                                                                */
/*     END.                                                                                        */
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = VentasxCliente.coddiv.
         ELSE x-Llave = x-LLave + VentasxCliente.coddiv.
         x-Llave = x-Llave + ' - ' + DimDivision.DesDiv + '|'.
         x-Llave = x-Llave + DimDivision.CanalVenta + ' - '  +  DimDivision.NomCanalVenta + '|'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
            x-Canal = DimCliente.canal
            x-Giro = DimCliente.gircli
            x-NroCard = DimCliente.nrocard
            x-CodDept = DimCliente.coddept
            x-CodProv = DimCliente.codprov
            x-CodDist = DimCliente.coddist
            x-ClfCli = DimCliente.clfcli
            x-Zona = "".
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = VentasxCliente.codcli.
             ELSE x-Llave = x-Llave + VentasxCliente.codcli.
             x-Llave = x-Llave + ' - ' + DimCliente.NomCli + '|'.
        END.
        /* CANAL CLIENTE */
        x-Canal = DimCliente.Canal + ' - ' + TRIM(DimCliente.NomCanal).
        /* GIRO DEL NEGOCIO */
        x-Giro = DimCliente.GirCli + ' - ' + TRIM(DimCliente.NomGirCli).
        /* Tarjeta Cliente Exclusivo */
        FIND DimTarjeta OF DimCliente NO-LOCK NO-ERROR.
        IF AVAILABLE DimTarjeta THEN x-NroCard = DimCliente.NroCard + ' - ' + TRIM(DimTarjeta.NomNroCard).
        ELSE x-NroCard = DimCliente.NroCard.
        /* DEPARTAMENTO, PROVINCIA Y DISTRITO */
        FIND DimUbicacion WHERE DimUbicacion.CodDepto = DimCliente.CodDept 
            AND DimUbicacion.CodProvi = DimCliente.CodProv 
            AND DimUbicacion.CodDistr = DimCliente.CodDist
            NO-LOCK NO-ERROR.
        IF AVAILABLE DimUbicacion 
            THEN ASSIGN
                    x-CodDept = DimCliente.CodDept + ' - ' + TRIM(DimUbicacion.NomDepto)
                    x-CodProv = DimCliente.CodProv + ' - ' + TRIM(DimUbicacion.Nomprovi)
                    x-CodDist = DimCliente.CodDist + ' - ' + TRIM(DimUbicacion.Nomdistr)
                    x-Zona = DimUbicacion.Zona + ' - ' + TRIM(DimUbicacion.NomZona).
        /* ZONA */
/*         IF DimCliente.CodDept = '15' AND DimCliente.CodProv = '01' THEN x-Zona = 'LMC'. */
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
         HEIGHT             = 4.08
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


