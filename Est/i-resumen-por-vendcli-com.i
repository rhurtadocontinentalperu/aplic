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

FOR EACH dwh_ventas_vendcli NO-LOCK WHERE dwh_ventas_vendcli.codcia = s-codcia
    AND dwh_ventas_vendcli.fecha >= x-NroFchR
    AND dwh_ventas_vendcli.fecha <= x-NroFchE
    AND dwh_ventas_vendcli.coddiv BEGINS x-CodDiv
    AND dwh_ventas_vendcli.codcli BEGINS x-CodCli
    AND ( x-CodCli = '' OR LOOKUP (dwh_ventas_vendcli.codven, x-CodVen) > 0 ),
    FIRST dwh_tiempo WHERE dwh_tiempo.codcia = s-codcia
    AND dwh_tiempo.fecha = dwh_ventas_vendcli.fecha NO-LOCK:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR VENDEDOR Y CLIENTE ' + 
        ' FECHA ' + STRING (dwh_Tiempo.NroDia, '99') +
        ' ' + dwh_Tiempo.NombreMes + ' ' + STRING (dwh_Tiempo.Periodo, '9999') +
        ' DIVISION ' + dwh_ventas_vendcli.coddiv + ' CLIENTE ' + dwh_ventas_vendcli.codcli + ' VENDEDOR ' + dwh_ventas_vendcli.codven + ' **'.
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
    x-Fecha = DATE(SUBSTRING(STRING(dwh_ventas_vendcli.fecha, '99999999'),7,2) + '/' +
                   SUBSTRING(STRING(dwh_ventas_vendcli.fecha, '99999999'),5,2) + '/' +
                   SUBSTRING(STRING(dwh_ventas_vendcli.fecha, '99999999'),1,4)).
    /* PERIODO ACTUAL */
    IF x-Fecha >= DesdeF AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[1]  = F-Salida[1]  + dwh_ventas_vendcli.Cantidad*/
            T-Vtamn[1]   = T-Vtamn[1]   + dwh_ventas_vendcli.ImpNacCIGV
            T-Vtame[1]   = T-Vtame[1]   + dwh_ventas_vendcli.ImpExtCIGV
            T-Ctomn[1]   = T-Ctomn[1]   + dwh_ventas_vendcli.CostoNacCIGV
            T-Ctome[1]   = T-Ctome[1]   + dwh_ventas_vendcli.CostoExtCIGV
            T-Promn[1]   = T-Promn[1]   + dwh_ventas_vendcli.PromNacCIGV
            T-Prome[1]   = T-Prome[1]   + dwh_ventas_vendcli.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ACTUAL */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF)) AND x-Fecha <= HastaF THEN DO:
        ASSIGN
            /*F-Salida[2]  = F-Salida[2]  + dwh_ventas_vendcli.Cantidad*/
            T-Vtamn[2]   = T-Vtamn[2]   + dwh_ventas_vendcli.ImpNacCIGV
            T-Vtame[2]   = T-Vtame[2]   + dwh_ventas_vendcli.ImpExtCIGV
            T-Ctomn[2]   = T-Ctomn[2]   + dwh_ventas_vendcli.CostoNacCIGV
            T-Ctome[2]   = T-Ctome[2]   + dwh_ventas_vendcli.CostoExtCIGV
            T-Promn[2]   = T-Promn[2]   + dwh_ventas_vendcli.PromNacCIGV
            T-Prome[2]   = T-Prome[2]   + dwh_ventas_vendcli.PromExtCIGV.
    END.
    /* PERIODO ANTERIOR */
    IF x-Fecha >= DATE(MONTH(DesdeF),DAY(DesdeF),YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[3]  = F-Salida[3]  + dwh_ventas_vendcli.Cantidad*/
            T-Vtamn[3]   = T-Vtamn[3]   + dwh_ventas_vendcli.ImpNacCIGV
            T-Vtame[3]   = T-Vtame[3]   + dwh_ventas_vendcli.ImpExtCIGV
            T-Ctomn[3]   = T-Ctomn[3]   + dwh_ventas_vendcli.CostoNacCIGV
            T-Ctome[3]   = T-Ctome[3]   + dwh_ventas_vendcli.CostoExtCIGV
            T-Promn[3]   = T-Promn[3]   + dwh_ventas_vendcli.PromNacCIGV
            T-Prome[3]   = T-Prome[3]   + dwh_ventas_vendcli.PromExtCIGV.
    END.
    /* ACUMULADO PERIODO ANTERIOR */
    IF x-Fecha >= DATE(01,01,YEAR(DesdeF) - 1) AND x-Fecha <= DATE(MONTH(HastaF),DAY(HastaF),YEAR(HastaF) - 1) THEN DO:
        ASSIGN
            /*F-Salida[4]  = F-Salida[4]  + dwh_ventas_vendcli.Cantidad*/
            T-Vtamn[4]   = T-Vtamn[4]   + dwh_ventas_vendcli.ImpNacCIGV
            T-Vtame[4]   = T-Vtame[4]   + dwh_ventas_vendcli.ImpExtCIGV
            T-Ctomn[4]   = T-Ctomn[4]   + dwh_ventas_vendcli.CostoNacCIGV
            T-Ctome[4]   = T-Ctome[4]   + dwh_ventas_vendcli.CostoExtCIGV
            T-Promn[4]   = T-Promn[4]   + dwh_ventas_vendcli.PromNacCIGV
            T-Prome[4]   = T-Prome[4]   + dwh_ventas_vendcli.PromExtCIGV.
    END.
    /* LLAVE INICIAL */
    IF RADIO-SET-Tipo = 2 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroMes, '99').  /*dwh_Tiempo.NombreMes.*/
        x-Llave = x-LLave + '|'.
    END.
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas_vendcli.coddiv + '|'.
         ELSE x-Llave = x-LLave + dwh_ventas_vendcli.coddiv + '|'.
         FIND gn-divi WHERE gn-divi.codcia = s-codcia
             AND gn-divi.coddiv = dwh_ventas_vendcli.coddiv
             NO-LOCK NO-ERROR.
         IF AVAILABLE gn-divi THEN x-Llave = x-Llave + gn-divi.CanalVenta + '|'.
         ELSE x-Llave = x-Llave + '|'.
    END.
    IF TOGGLE-CodCli = YES THEN DO:
        ASSIGN
             x-Canal   = ''
             x-Giro    = ''
             x-NroCard = ''
             x-Zona    = ''
             x-CodDept = ''
             x-CodProv = ''
             x-CodDist = ''
             x-ClfCli  = ''.
        IF TOGGLE-Resumen-Depto = NO THEN DO:
             IF x-Llave = '' THEN x-Llave = dwh_ventas_vendcli.codcli + '|'.
             ELSE x-Llave = x-Llave + dwh_ventas_vendcli.codcli + '|'.
        END.
        FIND gn-clie WHERE gn-clie.codcia = cl-codcia
            AND gn-clie.codcli = dwh_ventas_vendcli.codcli
            NO-LOCK NO-ERROR.
        IF AVAILABLE gn-clie THEN DO:
            ASSIGN
                x-Canal = gn-clie.canal
                x-Giro = gn-clie.gircli
                x-NroCard = gn-clie.nrocard
                x-CodDept = gn-clie.coddept
                x-CodProv = gn-clie.codprov
                x-CodDist = gn-clie.coddist
                x-ClfCli  = gn-clie.clfcli.
            /* ZONA */
            FIND TabDepto WHERE TabDepto.CodDepto = gn-clie.CodDept NO-LOCK NO-ERROR.
            IF AVAILABLE TabDepto THEN x-Zona = TabDepto.Zona.
            IF gn-clie.CodDept = '15' AND gn-clie.CodProv = '01' THEN x-Zona = 'LMC'.
        END.
        /* CANAL CLIENTE */
        FIND almtabla WHERE almtabla.Tabla = 'CN' AND almtabla.Codigo = x-Canal NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN x-Canal = x-Canal + ' - ' + TRIM(almtabla.Nombre).
        ELSE x-Canal = x-Canal + ' - '.
        /* GIRO DEL NEGOCIO */
        FIND almtabla WHERE almtabla.Tabla = 'GN' AND almtabla.Codigo = x-Giro NO-LOCK NO-ERROR.
        IF AVAILABLE almtabla THEN x-Giro = x-Giro + ' - ' + TRIM(almtabla.Nombre).
        ELSE x-Giro = x-Giro + ' - '.
        /* Tarjeta Cliente Exclusivo */
        FIND gn-card WHERE gn-card.NroCard = x-NroCard NO-LOCK NO-ERROR.
        IF AVAILABLE gn-card THEN x-NroCard = x-NroCard + ' - ' + TRIM(gn-card.NomCard).
        ELSE x-NroCard = x-NroCard + ' - '.
        /* DEPARTAMENTO */
        FIND TabDepto WHERE TabDepto.CodDepto = x-CodDept NO-LOCK NO-ERROR.
        /* PROVINCIA */
        FIND Tabprovi WHERE Tabprovi.CodDepto = x-CodDept AND Tabprovi.Codprovi = x-CodProv NO-LOCK NO-ERROR.
        /* DISTRITO */
        FIND Tabdistr WHERE Tabdistr.CodDepto = x-CodDept AND Tabdistr.Codprovi = x-codprov
            AND Tabdistr.Coddistr = x-coddist NO-LOCK NO-ERROR.
        /* ******* */
        IF AVAILABLE TabDepto THEN x-CodDept = x-CodDept + ' - ' + TRIM(TabDepto.NomDepto).
        ELSE x-CodDept = x-CodDept + ' - '.
        IF AVAILABLE Tabprovi THEN x-CodProv = x-CodProv + ' - ' + TRIM(Tabprovi.Nomprovi).
        ELSE x-CodProv = x-CodProv + ' - '.
        IF AVAILABLE Tabdistr THEN x-CodDist = x-CodDist + ' - ' + TRIM(Tabdistr.Nomdistr).
        ELSE x-CodDist = x-CodDist + ' - '.
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
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas_vendcli.codven + '|'.
         ELSE x-Llave = x-Llave + dwh_ventas_vendcli.codven + '|'.
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


