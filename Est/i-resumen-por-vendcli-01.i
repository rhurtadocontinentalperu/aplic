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

FOR EACH dwh_ventas_vendcli NO-LOCK WHERE dwh_ventas_vendcli.codcia = s-codcia
    AND dwh_ventas_vendcli.fecha >= INTEGER(STRING(YEAR(DesdeF),"9999") + STRING(MONTH(DesdeF),"99") + STRING(DAY(DesdeF), "99"))
    AND dwh_ventas_vendcli.fecha <= INTEGER(STRING(YEAR(HastaF),"9999") + STRING(MONTH(HastaF),"99") + STRING(DAY(HastaF), "99"))
    AND dwh_ventas_vendcli.coddiv BEGINS x-CodDiv
    AND dwh_ventas_vendcli.codcli BEGINS x-CodCli
    AND ( x-CodVen = '' OR LOOKUP (dwh_ventas_vendcli.codven, x-CodVen) > 0 ),
    FIRST dwh_Division OF dwh_ventas_vendcli NO-LOCK,
    FIRST dwh_Cliente NO-LOCK WHERE dwh_Cliente.CodCia = cl-codcia AND dwh_Cliente.CodCli = dwh_ventas_vendcli.codcli,
    FIRST dwh_Vendedor OF dwh_ventas_vendcli NO-LOCK,
    FIRST dwh_tiempo NO-LOCK WHERE dwh_tiempo.codcia = s-codcia AND dwh_tiempo.fecha = dwh_ventas_vendcli.fecha:
    IF x-CuentaReg = 0 OR ( x-CuentaReg MODULO x-MuestraReg ) = 0 THEN
        FILL-IN-Mensaje:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '** TABLA POR VENDEDOR Y CLIENTE ' + 
        ' FECHA ' + STRING (dwh_Tiempo.NroDia, '99') +
        ' ' + dwh_Tiempo.NombreMes + ' ' + STRING (dwh_Tiempo.Periodo, '9999') +
        ' DIVISION ' + dwh_ventas_vendcli.coddiv + ' CLIENTE ' + dwh_ventas_vendcli.codcli + ' VENDEDOR ' + dwh_ventas_vendcli.codven + ' **'.
    x-CuentaReg = x-CuentaReg + 1.
    /* ARMAMOS LA LLAVE */
    x-Llave = ''.
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
    IF RADIO-SET-Tipo = 3 THEN DO:
        IF x-Llave = '' THEN x-Llave = dwh_Tiempo.Campania.
        ELSE x-Llave = x-Llave + dwh_Tiempo.Campania.
        x-Llave = x-Llave + '|'.
        x-Llave = x-Llave + STRING(dwh_Tiempo.NroDia, '99') + '/' +  
                            STRING(dwh_Tiempo.NroMes, '99') + '/' +
                            STRING(dwh_Tiempo.Periodo, '9999').
        x-Llave = x-LLave + '|'.
    END.
    IF TOGGLE-CodDiv THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas_vendcli.coddiv + ' - ' + dwh_Division.DesDiv + '|'.
         ELSE x-Llave = x-LLave + dwh_ventas_vendcli.coddiv + ' - ' + dwh_Division.DesDiv + '|'.
         x-Llave = x-Llave + dwh_Division.CanalVenta + ' - ' + dwh_Division.NomCanalVenta + '|'.
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
             IF x-Llave = '' THEN x-Llave = dwh_ventas_vendcli.codcli.
             ELSE x-Llave = x-Llave + dwh_ventas_vendcli.codcli.
             x-Llave = x-Llave + ' - ' + dwh_Cliente.NomCli + '|'.
             /* Tarjeta Cliente Exclusivo */
             x-NroCard = dwh_Cliente.NroCard + ' - ' + TRIM(dwh_Cliente.NomNroCard).
        END.
        /* CANAL CLIENTE */
        x-Canal = dwh_Cliente.Canal + ' - ' + TRIM(dwh_Cliente.NomCanal).
        /* GIRO DEL NEGOCIO */
        x-Giro = dwh_Cliente.GirCli + ' - ' + TRIM(dwh_Cliente.NomGirCli).
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
        /* ZONA */
/*         IF dwh_Cliente.CodDept = '15' AND dwh_Cliente.CodProv = '01' THEN x-Zona = 'LMC'. */
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
        x-Llave = x-Llave + dwh_ventas_vendcli.tipo + '|'.
    END.
     /* ******************************************** */
     IF TOGGLE-CodVen = YES THEN DO:
         IF x-Llave = '' THEN x-Llave = dwh_ventas_vendcli.codven + ' - ' + dwh_Vendedor.NomVen + '|'.
         ELSE x-Llave = x-Llave + dwh_ventas_vendcli.codven + ' - ' + dwh_Vendedor.NomVen + '|'.
     END.
     /* ******************************************** */
     FIND tmp-detalle WHERE tmp-detalle.llave = x-Llave NO-ERROR.
     IF NOT AVAILABLE tmp-detalle THEN DO:
         CREATE tmp-detalle.
         tmp-detalle.llave = x-Llave.
     END.
     ASSIGN
         tmp-detalle.VtaxMesMe = tmp-detalle.VtaxMesMe + dwh_ventas_vendcli.ImpExtCIGV
         tmp-detalle.VtaxMesMn = tmp-detalle.VtaxMesMn + dwh_ventas_vendcli.ImpNacCIGV
         tmp-detalle.CtoxMesMe = tmp-detalle.CtoxMesMe + dwh_ventas_vendcli.CostoExtCIGV
         tmp-detalle.CtoxMesMn = tmp-detalle.CtoxMesMn + dwh_ventas_vendcli.CostoNacCIGV
         tmp-detalle.ProxMesMe = tmp-detalle.ProxMesMe + dwh_Ventas_vendcli.PromExtCIGV
         tmp-detalle.ProxMesMn = tmp-detalle.ProxMesMn + dwh_Ventas_vendcli.PromNacCIGV.
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
         HEIGHT             = 3.73
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


